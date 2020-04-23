# Aus Schritt 1.1
param sum_abs_unt := 5;
param sum_abs_kuz := 0;

# Knoten
set N:= {
    <"A">,
    <"B">
};

# Kanten
set E := {
<"A","B">,
<"B","A">
};

# Kapazitäten
param capl[E] :=
<"A","B"> 0 default 0;

param capu[E] :=
<"A","B"> 100 default 100;

param dist[E] :=
<"A","B"> 100 default 100;

# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"A"> 0 default 0;

# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"A"> 0 default 0;

# was kann unterbrochen werden
param ul[N] :=
<"A"> -100,
<"B"> -50 default -10;

# was kann unterbrochen werden
param uu[N] :=
<"A"> 0 default 0;

# was kann gekuerzt werden
param zl[N] :=
<"A"> 0 default 0;

# was kann gekuerzt werden
param zu[N] :=
<"A"> 0 default 0;

##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param B[N] :=
<"A"> 5,
<"B"> 0 default 10;
