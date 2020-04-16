# Knoten
set N:= {
    <"A">,
    <"B">
};

# Kanten
set E := {
<"A","B">
};

# Kapazitäten
param capl[E] :=
<"A","B"> 0;

param capu[E] :=
<"A","B"> 1000;

param dist[E] :=
<"A","B"> 100;

# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"A"> 0 default 0;

# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"A"> 10 default 10;

# was kann unterbrochen werden
param ul[N] :=
<"A"> 0 default 0;

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
<"A"> 1,
<"B"> -8;
