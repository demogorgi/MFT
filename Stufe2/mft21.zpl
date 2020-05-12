########################################################################################################################################################
#
# In diesem Schritt 2.1 werden die globalen und die gasbeschaffenheitsspezifischen Mengen ermittelt.
# Dabei werden aufgrund regulatorischer Vorgaben die Kapazitäten innerhalb der Gasbeschaffenheitszonen nicht restriktiv angesetzt.
# Lediglich die Überspeisekapazitäten zwischen den Gasbeschaffenheitszonen entsprechen den realen Werten.
# Die Bilanzen der NBZ für diesen Schritt ergeben sich in der Realität als Summe der Unterbrechungs- und Kürzungsmengen aus Schrtitt 1.1.
# Die Kantenkapazitäten für diesen Schritt ergeben sich aus den Eingangskapazitäten für Schritt 1.1, bereinigt um die in Schritt 1.1 ermittelten Flüsse.
#
########################################################################################################################################################

### Parameter
# Extremszenariomodellierung: die ri dienen dazu alle Szenarien zu modellieren. Jede Kombination von r1,r2,r3 stellt ein Extremszenario dar
param z1 := card(Z1); # Anzahl NBZ in der Zone GBH1
param z2 := card(Z2); # Anzahl NBZ in der Zone GBH2
set S := { 1 .. ( card(N) * z1 * z2 ) }; # Indizes der Extremszenarien
# Diese Klimmzüge werden hier benötigt, um alle Mengenverteilungskombinationen zu modellieren. Das geht in anderen Programmiersprachen deutlich einfacher.
param r1[<s, n> in S * N] := if z1 * z2 * ( cnt[n] - 1 ) + 1 <= s and s <= z1 * z2 * cnt[n] then 1 else 0 end;
param r2[<s, n> in S * N] := if cnt[n] <= z1 and ( s - cnt[n] ) mod z1 == 0 then 1 else 0 end;
param r3[<s, n> in S * N] := if z1 < cnt[n] and cnt[n] <= z1 + z2 and ( ( cnt[n] - z1 ) * z1 - z1 + 1 <= s mod ( z1 * z2 ) or ( cnt[n] == z1 + z2 and s mod ( z1 * z2 ) == 0 ) ) and s mod ( z1 * z2 ) <= ( cnt[n] - z1 ) * z1 then 1 else 0 end;
# Ausgabe aller Kombinationen
#do print "r1:";
#do forall <s, n> in S * N do print "s: ", s, " n: ", cnt[n] ,": ", r1[s, n];
#do print "r2:";
#do forall <s, n> in S * N do print "s: ", s, " n: ", cnt[n] ,": ", r2[s, n];
#do print "r3:";
#do forall <s, n> in S * N do print "s: ", s, " n: ", cnt[n] ,": ", r3[s, n];

### Variablen
# Kantenflussvariablen für jedes Szenario
var F[S * E] real >= 0;

# Bilanzvariablen
var BalanceSN[<s,n> in S * N] >= -infinity <= infinity;

# Regelenergie
var Glo >= -infinity;
var Glo_abs >= 0;
var Glo_pos >= 0;
var Glo_neg >= 0;
#
var GBH1 >= -infinity;
var GBH1_abs >= 0;
var GBH1_pos >= 0;
var GBH1_neg >= 0;
#
var GBH2 >= -infinity;
var GBH2_abs >= 0;
var GBH2_pos >= 0;
var GBH2_neg >= 0;
#
### Zielfunktion
# Minimiere Regelenergie gemäß Reihenfolge
minimize obj: Glo_abs + 10 * ( GBH1_abs + GBH2_abs );

### Nebenbedingungen
# Fehlmengen und Betrag der Fehlmengen
subto fehlG1:
      Glo_abs == Glo_pos + Glo_neg;
subto fehlG2:
      Glo == Glo_pos - Glo_neg;
subto fehlGBH1_1:
      GBH1_abs == GBH1_pos + GBH1_neg;
subto fehlGBH1_2:
      GBH1 == GBH1_pos - GBH1_neg;
subto fehlGBH2_1:
      GBH2_abs == GBH2_pos + GBH2_neg;
subto fehlGBH2_2:
      GBH2 == GBH2_pos - GBH2_neg;

# Kapazitätsgrenzen müssen eingehalten werden
subto capacities2_4:
      forall <s> in S: forall <i, j> in E: capl[i, j] <= F[s, i, j] <= capu[i, j];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flowBalance1:
      forall <s, n> in S * N: BalanceSN[s,n] == BalanceN[n] + r1[s,n] * Glo + r2[s,n] * GBH1 + r3[s,n] * GBH2;
subto flowBalance2:
      forall <s, n> in S * N: sum <i, n> in E: F[s, i, n] - sum <n, i> in E: F[s, n, i] == - BalanceSN[s, n];

