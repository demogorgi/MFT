
### Parameter

# Extremszenariomodellierung: die ri dienen dazu alle Szenarien zu modellieren. Jede Kombination von r1,r2,r3 stellt ein Extremszenario dar
param z1 := card(Z1);
param z2 := card(Z2);
set S := { 1 .. ( card(N) * z1 * z2 ) };
param r1[<s, n> in S * N] := if z1 * z2 * ( cnt[n] - 1 ) + 1 <= s and s <= z1 * z2 * cnt[n] then 1 else 0 end;
param r2[<s, n> in S * N] := if cnt[n] <= z1 and ( s - cnt[n] ) mod z1 == 0 then 1 else 0 end;
param r3[<s, n> in S * N] := if z1 < cnt[n] and cnt[n] <= z1 + z2 and ( ( cnt[n] - z1 ) * z1 - z1 + 1 <= s mod ( z1 * z2 ) or ( cnt[n] == z1 + z2 and s mod ( z1 * z2 ) == 0 ) ) and s mod ( z1 * z2 ) <= ( cnt[n] - z1 ) * z1 then 1 else 0 end;
#do print "r1:";
#do forall <s, n> in S * N do print "s: ", s, " n: ", cnt[n] ,": ", r1[s, n];
#do print "r2:";
#do forall <s, n> in S * N do print "s: ", s, " n: ", cnt[n] ,": ", r2[s, n];
#do print "r3:";
#do forall <s, n> in S * N do print "s: ", s, " n: ", cnt[n] ,": ", r3[s, n];

# Koeffizient für Parabel auf [0,bound] mit dem Wert s an der Stelle bound.
defnumb koeffizient(max_bound,s,bound) := if bound == 0 then
                                             0
                                          else
                                             s / ( max_bound * abs(bound) )
                                          end;

# ermittelt die Größenordnung einer Zahl. Wird genutzt um numerische Probleme bei den Puffer-, Unterbrechungs- und Kürzungskosten zu vermeiden.
defnumb groessenordnung(num) := if num == 0 then
                                   1.0
                                else
                                   if abs(num) == num then
                                        10.0 ** floor(log(abs(num)))
                                   else
                                      - 10.0 ** floor(log(abs(num)))
                                   end
                                end;

# Maximal auftretende Unterbrechungsgrenze (Betrag)
param ulmax := max <n> in N : abs(ul[n]);
param uumax := max <n> in N : abs(uu[n]);
param umax := max(ulmax,uumax);
#
param aDul[<i> in N] := koeffizient(umax,10 * groessenordnung(umax),ul[i]);
param aDuu[<i> in N] := koeffizient(umax,10 * groessenordnung(umax),uu[i]);

# Maximal auftretende Kürzungsgrenze (Betrag)
param zlmax := max <n> in N : abs(zl[n]);
param zumax := max <n> in N : abs(zu[n]);
param zmax := max(zlmax,zumax);
#
param aDzl[<i> in N] := koeffizient(zmax,10 * groessenordnung(zmax),zl[i]);
param aDzu[<i> in N] := koeffizient(zmax,10 * groessenordnung(zmax),zu[i]);

### Variablen
# Kantenflussvariablen
var F[S * E] real >= 0;

# Bilanzvariablen
var BalanceSN[<s,n> in S * N] >= -infinity <= infinity;

# Unterbrechungsmodell
var u[N] real >= -infinity;
var unt_pos[N] real >= 0;
var unt_neg[N] real >= 0;
var unt_abs[N] real >= 0;
var crul[N] real >= 0;
var cruu[N] real >= 0;
var cru[N] real >= 0;
# Kürzungsmodell
var z[N] real >= -infinity;
var kuz_pos[N] real >= 0;
var kuz_neg[N] real >= 0;
var kuz_abs[N] real >= 0;
var crzl[N] real >= 0;
var crzu[N] real >= 0;
var crz[N] real >= 0;

### Zielfunktion
# Minimiere Ratioabweichungskosten
minimize obj: sum <n> in N: ( cru[n] + crz[n] );

# Quadratische Kosten Ratioabweichung Unterbrechung
subto quadraticCostsURatioLb:
      forall <i> in N: crul[i] >= aDul[i] * unt_neg[i]^2;
subto quadraticCostsURatioUb:
      forall <i> in N: cruu[i] >= aDuu[i] * unt_pos[i]^2;
subto CostsRatioUbLb:
      forall <i> in N: cru[i] == crul[i] + cruu[i];
# Quadratische Kosten Ratioabweichung Slack
subto quadraticCostsZRatioLb:
      forall <i> in N: crzl[i] >= aDzl[i] * kuz_neg[i]^2;
subto quadraticCostsZRatioUb:
      forall <i> in N: crzu[i] >= aDzu[i] * kuz_pos[i]^2;
subto CostsRatioZUbLb:
      forall <i> in N: crz[i] == crzl[i] + crzu[i];

# Unterbrechungen
# u < 0 -> Entryunterbrechung
# u > 0 -> Exitunterbrechung
# Betrag der Unterbrechung
subto uabs1:
      forall <n> in N: u[n] == unt_pos[n] - unt_neg[n];
subto uabs2:
      forall <n> in N: unt_abs[n] == unt_pos[n] + unt_neg[n];
# Unterbrechungsgrenzen
subto unterbrechungsgrenzen:
      forall <n> in N: ul[n] <= u[n] <= uu[n];
# Unterbrechungsbetragssumme
subto unterbrechungsbetragssumme:
      sum_abs_unt == sum <n> in N: unt_abs[n];

# Kürzungen
# k < 0 -> Entrykürzung
# k > 0 -> Exitkürzung
# Betrag der Kürzungen
subto kabs1:
      forall <n> in N: z[n] == kuz_pos[n] - kuz_neg[n];
subto kabs2:
      forall <n> in N: kuz_abs[n] == kuz_pos[n] + kuz_neg[n];
# Kürzungsgrenzen
subto kuerzungsgrenzen:
      forall <n> in N: zl[n] <= z[n] <= zu[n];
# Kürzungsbetragssumme
subto kuerzungsbetragssumme:
      sum_abs_kuz == sum <n> in N: kuz_abs[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto capacities2_4:
      forall <s> in S: forall <i, j> in E: capl[i, j] <= F[s, i, j] <= capu[i, j];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flowBalance1:
      forall <s, n> in S * N: BalanceSN[s,n] == BalanceN[n] + r1[s,n] * Glo + r2[s,n] * GBH1 + r3[s,n] * GBH2 + u[n] + z[n];
subto flowBalance2:
      forall <s, n> in S * N: sum <i, n> in E: F[s, i, n] - sum <n, i> in E: F[s, n, i] == - BalanceSN[s, n];

