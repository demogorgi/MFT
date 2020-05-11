##################################################################################################
# Knoten
set Z1 := {
<"A">,
<"B">,
<"C">
};

set Z2 := {
<"D">,
<"E"> 
};

set N := Z1 union Z2;

# nur für das stochastische Modell relevant
# ACHTUNG: Die Numerierung muss zu Z1 und Z2 passen!!! Also die Knoten aus Z1 bekommen aufeinanderfolgende Zahlen und die aus Z2 auch.
param cnt[N] :=
<"A"> 1,
<"B"> 2,
<"C"> 3,
<"D"> 4,
<"E"> 5;

# Kanten
set E := {
<"A","B">,
<"B","A">,
<"A","D">,
<"D","A">,
<"A","C">,
<"C","A">,
<"B","C">,
<"C","B">,
<"D","E">,
<"E","D">
};

# Kapazitäten
param capl[E] :=
<"A","B"> 0 default 0;

param capu[E] :=
<"A","B"> 1000,
<"B","A"> 1000 default 0;

# was kann unterbrochen werden
param ul[N] :=
<"B"> -5 default -10;

# was kann unterbrochen werden
param uu[N] :=
<"B"> 5 default 10;

# was kann gekuerzt werden
param zl[N] :=
<"A"> -10 default -10;

# was kann gekuerzt werden
param zu[N] :=
<"A"> 10 default 10;


##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param BalanceN[N] :=
<"A"> 100,
<"B"> 25,
<"C"> 40,
<"D"> -60,
<"E"> 10;

