# Konstanten C1, C2  und C3 in der ZF sorgen dafür, dass erst alles gepuffert wird, was hilft
# bevor unterbrochen wird und dass alles unterbrochen wird, was hilft, bevor gekürzt wird.
# Falls alles nicht hilft werden noch die Schlupfvariablen ZZ genutzt. Die ZZ-Variablen
# helfen in Schritt 1.2, die Kürzungsgrenzen passend zu skalieren.
param c1 := 1.1 * sum <n> in N: max(abs(pl[n]),abs(pu[n]));
param C1 := if c1 < 10 then 10 else c1 end;
param c2 := 1.1 * sum <n> in N: max(abs(ul[n]),abs(uu[n]));
param C2 := if c2 < 10 then 10 else c2 end;
param c3 := 1.1 * sum <n> in N: max(abs(zl[n]),abs(zu[n]));
param C3 := if c3 < 10 then 10 else c3 end;
do print "c1 = ", c1, ", C1 = ", C1;
do print "c2 = ", c2, ", C2 = ", C2;
do print "c3 = ", c3, ", C3 = ", C3;

### Variablen
# Kantenflussvariablen
var f[E] real >= 0;
# Puffermodell
var p[N] real >= -infinity;
var p_pos[N] real >= 0;
var p_neg[N] real >= 0;
var p_abs[N] real >= 0;
var sum_abs_p real >= 0;
# Unterbrechungsmodell
var u[N] real >= -infinity;
var unt_pos[N] real >= 0;
var unt_neg[N] real >= 0;
var unt_abs[N] real >= 0;
var sum_abs_unt real >= 0;
# Kürzungsmodell
var z[N] real >= -infinity;
var kuz_pos[N] real >= 0;
var kuz_neg[N] real >= 0;
var kuz_abs[N] real >= 0;
var sum_abs_kuz real >= 0;
## Schlupfmodell
#var ZZ[N] real >= -infinity;
#var ZZ_pos[N] real >= 0;
#var ZZ_neg[N] real >= 0;
#var ZZ_abs[N] real >= 0;
#var sum_abs_ZZ real >= 0;

### Zielfunktion
# Minimiere Puffern, Unterbrechen, Kürzen unter Einhalteung der Reihenfolge
#minimize obj: sum <n> in N: ( p_abs[n] + C1 * unt_abs[n] + ( C1 + C2 ) * kuz_abs[n] + ( C1 + C2 + C3 ) * ZZ_abs[n] ) ;
minimize obj: sum <n> in N: ( p_abs[n] + C1 * unt_abs[n] + ( C1 + C2 ) * kuz_abs[n] ) ;

### Nebenbedingungen
# Betrag des Pufferns
subto pabs1:
      forall <n> in N: p[n] == p_pos[n] - p_neg[n];
subto pabs2:
      forall <n> in N: p_abs[n] == p_pos[n] + p_neg[n];
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
## Betrag des Schlupfes
#subto sabs1:
#      forall <n> in N: ZZ[n] == ZZ_pos[n] - ZZ_neg[n];
#subto sabs2:
#      forall <n> in N: ZZ_abs[n] == ZZ_pos[n] + ZZ_neg[n];

# Netzpuffernutzung
# p < 0 -> Befüllung
# p > 0 -> Entnahme
# Puffergrenzen müssen eingehalten werden
subto puffer1:
      forall <n> in N: pl[n] <= p[n] <= pu[n];
# Input für mft12
subto puffer2:
      sum_abs_p == sum <n> in N: p_abs[n];

# Unterbrechung
# u < 0 -> Entry-Unterbrechung
# u > 0 -> Exit-Unterbrechung
# Unterbrechungsgrenzen müssen eingehalten werden
subto unterbrechung1:
      forall <n> in N: ul[n] <= u[n] <= uu[n];
# Input für mft12
subto unterbrechung2:
      sum_abs_unt == sum <n> in N: unt_abs[n];

# Kürzung
# z < 0 -> Entry-Kürzung
# z > 0 -> Exit-Kürzung
# Input für mft12
subto kuerzung2:
      sum_abs_kuz == sum <n> in N: kuz_abs[n];

## Schlupf
## Input für mft12
#subto schlupf:
#      sum_abs_ZZ == sum <n> in N: ZZ_abs[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto kantenkapa:
      forall <i, j> in E: capl[i, j] <= f[i, j] <= capu[i, j];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flussbilanz:
      # rein - raus + Puffer + Unterbrechung + Kürzung = - Bilanz (Bilanz>0 Überdeckung, <0 Unterdeckung)
      forall <n> in N: sum <i, n> in E: f[i, n] - sum <n, i> in E: f[n, i] + p[n] + u[n] + z[n] == - B[n];

