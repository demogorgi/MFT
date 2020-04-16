# Knoten
set N:= {
    <"A">,
    <"B">,
    <"C">
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
<"A","B"> 1 default 1;

# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"A"> 0 default 0;

# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"A"> 0 default 0;

# was kann unterbrochen werden
param ul[N] :=
<"A"> -10,
<"B"> -1,
<"C"> -100;

# was kann unterbrochen werden
param uu[N] :=
<"A"> 10,
<"B"> 1,
<"C"> 100;

# was kann gekuerzt werden
param zl[N] :=
<"A"> 0 default 0;

# was kann gekuerzt werden
param zu[N] :=
<"A"> 0 default 0;

##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param B[N] :=
<"A"> 10,
<"B"> 0,
<"C"> 0;
