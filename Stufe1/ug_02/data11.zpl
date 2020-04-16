# Knoten
set N:= {
    <"A">,
    <"B">,
    <"C">,
    <"D">
};

# Kanten
set E := {
<"A","D">,
<"C","D">,
<"B","C">,
<"B","D">
};

# Kapazitäten
param capl[E] :=
<"A","D"> 0 default 0;

param capu[E] :=
<"A","D"> 1 default 1;

param dist[E] :=
<"A","D"> 100,
<"B","D"> 100 default 50;

# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"A"> 0 default 0;

# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"A"> 0 default 0;

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
<"B"> 1,
<"C"> 0,
<"D"> -2;
