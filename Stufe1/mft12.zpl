# Puffer-/Unterbrechungs-/Kürzungs-/Slackkosten
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

# Maximal auftretende Puffergrenze (Betrag)
param plmax := max <n> in N : abs(pl[n]);
param pumax := max <n> in N : abs(pu[n]);
param pmax := max(plmax,pumax);
#
param aDpl[<i> in N] := koeffizient(pmax,100 * groessenordnung(pmax),pl[i]);
param aDpu[<i> in N] := koeffizient(pmax,100 * groessenordnung(pmax),pu[i]);

# Maximal auftretende Unterbrechungsgrenze (Betrag)
param ulmax := max <n> in N : abs(ul[n]);
param uumax := max <n> in N : abs(uu[n]);
param umax := max(ulmax,uumax);
#
param aDul[<i> in N] := koeffizient(umax,100 * groessenordnung(umax),ul[i]);
param aDuu[<i> in N] := koeffizient(umax,100 * groessenordnung(umax),uu[i]);

# Maximal auftretende Kürzungsgrenze (Betrag)
param zlmax := max <n> in N : abs(zl[n]);
param zumax := max <n> in N : abs(zu[n]);
param zmax := max(zlmax,zumax);
#
param aDzl[<i> in N] := koeffizient(zmax,100 * groessenordnung(zmax),zl[i]);
param aDzu[<i> in N] := koeffizient(zmax,100 * groessenordnung(zmax),zu[i]);

## Maximal auftretende Slacks
param Zmax := sum_abs_Z;

### Variablen
# Kantenflussvariablen
var f[E] real >= 0;
# Puffernutzung
var p[N] real >= -infinity;
var p_pos[N] real >= 0;
var p_neg[N] real >= 0;
var p_abs[N] real >= 0;
var crpl[N] real >= 0;
var crpu[N] real >= 0;
var crp[N] real >= 0;
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
# Slackmodell
var Z[N] >= -infinity;
var Z_neg[N] real >= 0;
var Z_pos[N] real >= 0;
var Z_abs[N] real >= 0;
var crZl[N] real >= 0;
var crZu[N] real >= 0;
var crZ[N] real >= 0;

### Zielfunktion
# Minimiere Kosten für Puffer, Unterbrechung, Kürzung, Slack
minimize obj: sum <n> in N: ( crp[n] + cru[n] + crz[n] + crZ[n] );

# Quadratische Kosten Ratioabweichung Puffer
subto quadraticCostsBRatioLb:
      forall <i> in N: crpl[i] >= aDpl[i] * p_neg[i]^2;
subto quadraticCostsBRatioUb:
      forall <i> in N: crpu[i] >= aDpu[i] * p_pos[i]^2;
subto CostsRatioBbLb:
      forall <i> in N: crp[i] == crpl[i] + crpu[i];
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
# Z
subto CostsRatioZZ:
      forall <i> in N: crZ[i] >= 100 * Z_abs[i]^2;

# Kann in Mathematica genutzt werden, um die Kostenfunktionen zu plotten. Hinter der jeweils letzten Funktion muss ein "," entfernt werden.
# Und "e-06" etc. muss ersetzt werden durch "*^-6".
do print "(*Pufferkosten*)Plot[{";
do forall <n> in N do print "(*", n, "*)Piecewise[{{", aDpl[n], " * p^2 ,", pl[n], " <= p <= 0 }, {", aDpu[n], " * p^2 , 0 <= p <= ", pu[n], "}, Nothing}],";
do print "}, {p, ", min <n> in N: pl[n], ", ", max <n> in N: pu[n], "}, PlotRange -> All]";

do print "(*Unterbrechungskosten*)Plot[{";
do forall <n> in N do print "(*", n, "*)Piecewise[{{", aDul[n], " * u^2 ,", ul[n], " <= u <= 0 }, {", aDuu[n], " * u^2 , 0 <= u <= ", uu[n], "}, Nothing}],";
do print "}, {u, ", min <n> in N: ul[n], ", ", max <n> in N: uu[n], "}, PlotRange -> All]";

do print "(*Kürzungskosten*)Plot[{";
do forall <n> in N do print "(*", n, "*)Piecewise[{{", aDzl[n], " * z^2 ,", zl[n], " <= z <= 0 }, {", aDzu[n], " * z^2 , 0 <= z <= ", zu[n], "}, Nothing}],";
do print "}, {z, ", min <n> in N: zl[n], ", ", max <n> in N: zu[n], "}, PlotRange -> All]";

# Puffern
# p < 0 -> Befüllung des Puffers
# u > 0 -> Entnahme aus dem Puffer
# Betrag des Pufferns
subto pabs1:
      forall <n> in N: p[n] == p_pos[n] - p_neg[n];
subto pabs2:
      forall <n> in N: p_abs[n] == p_pos[n] + p_neg[n];
# Puffergrenzen
subto puffergrenzen:
      forall <n> in N: pl[n] <= p[n] <= pu[n];
# Unterbrechungsbetragssumme
subto pufferbetragssumme:
      sum_abs_p == sum <n> in N: p_abs[n];

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
subto kuerzungsbetragssumme:
      sum_abs_kuz == sum <n> in N: kuz_abs[n];

# Slackvariable, um das Modell in jedem Fall zulässig zu machen
subto slack1:
      forall <n> in N: Z[n] == Z_pos[n] - Z_neg[n];
subto slack2:
      forall <n> in N: Z_abs[n] == Z_pos[n] + Z_neg[n];
subto slackbetragssumme:
      sum_abs_Z == sum <n> in N: Z_abs[n];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flussbilanz:
      # Zufluss - Abfluss + Puffer + Unterbrechung + Kürzung = - Bilanz (Bilanz>0 Überdeckung, <0 Unterdeckung)
      forall <n> in N: sum <i, n> in E: f[i, n] - sum <n, i> in E: f[n, i] + p[n] + u[n] + z[n] + Z[n] == - B[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto kantenkapa:
      forall <i, j> in E: capl[i, j] <= f[i, j] <= capu[i, j];

