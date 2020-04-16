# Konstante sorgt in der ZF dafür, dass erst alles unterbrochen wird, was hilft
param C := if sum <n> in N: max(abs(ul[n]),abs(uu[n])) == 0 then 100 else sum <n> in N: max(abs(ul[n]),abs(uu[n])) end;

### Variablen
# Kantenflussvariablen
var f[E] real >= 0;
# Puffermodell
var p[N] real >= -infinity;
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

### Zielfunktion
# Minimiere Kosten
minimize obj: sum <n> in N: unt_abs[n] + C * sum <n> in N: kuz_abs[n] ;

### Nebenbedingungen
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

# Netzpuffernutzung
# p < 0 -> Befüllung
# p > 0 -> Entnahme
subto puffer:
      forall <n> in N: pl[n] <= p[n] <= pu[n];

subto unterbrechung1:
      forall <n> in N: ul[n] <= u[n] <= uu[n];
subto unterbrechung2:
      sum_abs_unt == sum <n> in N: unt_abs[n];

#subto kuerzung1:
#      forall <n> in N: zl[n] <= z[n] <= zu[n];
subto kuerzung2:
      sum_abs_kuz == sum <n> in N: kuz_abs[n];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flussbilanz:
      # rein - raus + Puffer + Unterbrechung + Kürzung = - Bilanz (Bilanz>0 Überdeckung, <0 Unterdeckung)
      forall <n> in N: sum <i, n> in E: f[i, n] - sum <n, i> in E: f[n, i] + p[n] + u[n] + z[n] == - B[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto kantenkapa:
      forall <i, j> in E: capl[i, j] <= f[i, j] <= capu[i, j];

