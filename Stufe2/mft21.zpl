### Parameter
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

### Variablen
# Kantenflussvariablen
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
var Lok[<n> in N] >= -infinity;
var Lok_abs[<n> in N] >= 0;
var Lok_pos[<n> in N] >= 0;
var Lok_neg[<n> in N] >= 0;

### Zielfunktion
# Minimiere Regelenergie
minimize obj: Glo_abs + 10 * ( GBH1_abs + GBH2_abs ) + 100 * sum <n> in N: Lok_abs[n];

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
subto fehlL1:
      forall <n> in N: Lok_abs[n] == Lok_pos[n] + Lok_neg[n];
subto fehlL2:
      forall <n> in N: Lok[n] == Lok_pos[n] - Lok_neg[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto capacities2_4:
      forall <s> in S: forall <i, j> in E: capl[i, j] <= F[s, i, j] <= capu[i, j];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flowBalance1:
      forall <s, n> in S * N: BalanceSN[s,n] == BalanceN[n] + r1[s,n] * Glo + r2[s,n] * GBH1 + r3[s,n] * GBH2 + Lok[n];
subto flowBalance2:
      forall <s, n> in S * N: sum <i, n> in E: F[s, i, n] - sum <n, i> in E: F[s, n, i] == - BalanceSN[s, n];

