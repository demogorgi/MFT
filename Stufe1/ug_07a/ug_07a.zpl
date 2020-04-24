# Knoten
set N:= {
    <"A">,
    <"B">,
    <"C">,
    <"D">,
    <"E">
};

# Kanten
set E := {
<"A","B">,
<"A","C">,
<"A","D">,
<"A","E">,
<"B","C">,
<"C","D">,
<"D","E">
};

# Kapazitäten
param capl[E] :=
<"A","B"> 0 default 0;

param capu[E] :=
<"A","B"> 100 default 100;

param dist[E] :=
<"A","B"> 0.5,
<"A","C"> 1,
<"A","D"> 1,
<"A","E"> 1 default 0;

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
<"A"> 40,
<"B"> -10,
<"C"> -10,
<"D"> -10,
<"E"> -10;
