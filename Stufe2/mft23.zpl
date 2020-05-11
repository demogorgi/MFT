
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

# Polynom 2. Grades (Scheitelpunktform) wird für Kostenfunktionen verwendet. Scheitelpunkt ist S(d|e).
defnumb h(x, a, d, e) := a * ( x - d ) ** 2 + e;

# Berechnung Position des k-ten Linearisierungsknotens
defnumb getKnot(k, lb, ub, numIntervals) := if k == 0 then lb else lb + k * ( ub - lb ) / numIntervals end;

# Berechnung der Steigung des k-ten Linearitätsbereichs
defnumb getSlope(knotkminus1, knotk, a, d, e) := if knotk == knotkminus1 then 0 else ( h(knotk, a, d, e) - h(knotkminus1, a, d, e) ) / ( knotk - knotkminus1 ) end;

# Intervallanzahlen für Linearisierungen
param numIntervals := 6000;

# Abweichung vom gemeinsamem Ratio
param d := 0;
param e := 0;
param a := 1;

# Modellierung Kosten Abweichung vom gemeinsamen Ratio
# Anzahl der Linearitätsbereiche
set knotIndicesD := { 0 .. numIntervals };
# Äquidistante Zerlegung von -1 bis 1
param knotsD[<k> in knotIndicesD] := getKnot(k, -100, 100, numIntervals);
#param knotsD[<k> in knotIndicesD] := getKnot2(k, a, d, e, e, wmax, numIntervals); 
param slope[<k> in { 1 .. numIntervals }] := getSlope(knotsD[k-1], knotsD[k], a, d, e);
## Nur stdout
#do print "---------> knotsD:";
#do forall <k> in knotIndicesD do print knotsD[k];
#do print "---------> InfoD: (knotsD[k-1], h(knotsD[k-1])), (knotsD[k], h(knotsD[k])), slope"; 
#do forall <k> in { 1 .. numIntervals } do print "(", knotsD[k-1], ", ", h(knotsD[k-1], a, d, e), "), (", knotsD[k], ", ", h(knotsD[k], a, d, e), "), ", slope[k];  
#do print "---------> Linearisierung:";
#do forall <k> in { 1 .. numIntervals } do print slope[k], " * ( x - ", knotsD[k], " ) + ", h(knotsD[k], a, d, e);
#do print "(*-dev-----> Originalfunktion:*)";
#do print "Plot[";
#do print "Piecewise[{{", a, "* ( x - (", d, ") )^2 + ", e, ", ", -1, " <= x <= ", 1, "}, Nothing}],";
#do print " {x,-1,1}]";

# Big-Ms für Produktmodellierung
param Mu := a * ( sum <n> in N: max(abs(ul[n]),abs(uu[n])) ) ** 2;
param Mz := a * ( ( sum <n> in N: abs(BalanceN[n]) ) / ( min <n> in N: min(abs(ul[n]), abs(uu[n])) ) ) ** 2;
do print "Mu = ", Mu;
do print "Mz = ", Mz;

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
var cru[N] real >= 0;
var cru_x_p[N] real >= 0;
# Kürzungsmodell
var z[N] real >= -infinity;
var kuz_pos[N] real >= 0;
var kuz_neg[N] real >= 0;
var kuz_abs[N] real >= 0;
var crz[N] real >= 0;
var crz_x_q[N] real >= 0;

var p[N] binary;
var q[N] binary;

# Unterbrechungsratio
var Ru real >= 0 <= 1;
var x[N] real >= -1 <= 1;
# Kürzungsratio
var Rz real >= 0 <= 1;
var y[N] >= -infinity; #-1 <= 1;

### Zielfunktion
# Minimiere Ratioabweichungskosten; der letzte Term dient dazu bei Kosten von 0 so viele mit ins Boot zu holen wie möglich
minimize obj: sum <n> in N: cru_x_p[n] + sum <n> in N: crz_x_q[n] + sum <n> in N: ( q[n] + p[n] );

### Nebenbedingungen
# Konvexe Kosten Ratioabweichung Unterbrechung
subto convexCostsURatio:
      forall <i, k> in N * { 1 .. numIntervals }: cru[i] >= slope[k] * ( x[i] - knotsD[k] ) + h(knotsD[k], a, d, e);
# Konvexe Kosten Ratioabweichung Kuerzung
subto convexCostsZRatio:
      forall <i, k> in N * { 1 .. numIntervals }: crz[i] >= slope[k] * ( y[i] - knotsD[k] ) + h(knotsD[k], a, d, e);

subto prod1:
      forall <n> in N: Mu * p[n] >= unt_abs[n];
subto prod2:
      forall <n> in N: Mz * q[n] >= kuz_abs[n];

subto prods1:
      forall <n> in N: cru_x_p[n] <= Mu * p[n];
subto prods2:
      forall <n> in N: cru_x_p[n] <= cru[n];
subto prods3:
      forall <n> in N: cru_x_p[n] >= cru[n] - Mu * ( 1 - p[n] );

subto prodz1:
      forall <n> in N: crz_x_q[n] <= Mz * q[n];
subto prodz2:
      forall <n> in N: crz_x_q[n] <= crz[n];
subto prodz3:
      forall <n> in N: crz_x_q[n] >= crz[n] - Mz * ( 1 - q[n] );

#
subto unterbrechungsgrenzen:
      forall <n> in N: ul[n] <= u[n] <= uu[n];
subto unterbrechungsbetragssumme:
      sum_abs_unt == sum <n> in N: unt_abs[n];

subto unterbrechungsratio1:
      forall <n> in N do if ul[n] < 0 and uu[n] > 0 then - unt_neg[n]/ul[n] + unt_pos[n]/uu[n] + x[n] == Ru end;
subto unterbrechungsratio2:
      forall <n> in N do if ul[n] == 0 and uu[n] > 0 then unt_pos[n]/uu[n] + x[n] == Ru end;
subto unterbrechungsratio3:
      forall <n> in N do if ul[n] < 0 and uu[n] == 0 then - unt_neg[n]/ul[n] + x[n] == Ru end;
subto unterbrechungsratio4:
      forall <n> in N do if ul[n] == 0 and uu[n] == 0 then unt_neg[n] + unt_pos[n] == 0 end;
#
#
#subto kuerzungsgrenzen:
#      forall <n> in N: zl[n] <= z[n] <= zu[n];
subto kuerzungsbetragssumme:
      sum_abs_kuz == sum <n> in N: kuz_abs[n];

subto kuerzungsratio1:
      forall <n> in N do if zl[n] < 0 and zu[n] > 0 then - kuz_neg[n]/zl[n] + kuz_pos[n]/zu[n] + y[n] == Rz end;
subto kuerzungsratio2:
      forall <n> in N do if zl[n] == 0 and zu[n] > 0 then kuz_pos[n]/zu[n] + y[n] == Rz end;
subto kuerzungsratio3:
      forall <n> in N do if zl[n] < 0 and zu[n] == 0 then - kuz_neg[n]/zl[n] + y[n] == Rz end;
subto kuerzungsratio4:
      forall <n> in N do if zl[n] == 0 and zu[n] == 0 then kuz_neg[n] + kuz_pos[n] == 0 end;


# Betrag der Unterbrechung
subto uabs1:
      forall <n> in N: u[n] == unt_pos[n] - unt_neg[n];
subto uabs2:
      forall <n> in N: unt_abs[n] == unt_pos[n] + unt_neg[n];
# Betrag der Kürzungen
subto kabs1:
      forall <n> in N: z[n] == kuz_pos[n] - kuz_neg[n];
subto kabs2:
      forall <n> in N: kuz_abs[n] == kuz_pos[n] + kuz_neg[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto capacities2_4:
      forall <s> in S: forall <i, j> in E: capl[i, j] <= F[s, i, j] <= capu[i, j];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flowBalance1:
      forall <s, n> in S * N: BalanceSN[s,n] == BalanceN[n] + r1[s,n] * Glo + r2[s,n] * GBH1 + r3[s,n] * GBH2 + u[n] + z[n];
subto flowBalance2:
      forall <s, n> in S * N: sum <i, n> in E: F[s, i, n] - sum <n, i> in E: F[s, n, i] == - BalanceSN[s, n];

