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
<"B","A">,
#
<"C","D">,
<"D","C">,
<"C","E">,
<"E","C">
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
<"A"> -20,
<"B"> -40 default -10;

# was kann unterbrochen werden
param uu[N] :=
<"A"> 0 default 0;

# was kann gekuerzt werden
param zl[N] :=
<"A"> -100,
<"B"> -80,
<"C"> -70,
<"D"> -60,
<"E"> -50;

# was kann gekuerzt werden
param zu[N] :=
<"A"> 100,
<"B"> 80,
<"C"> 70,
<"D"> 60,
<"E"> 50;

##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param B[N] :=
<"A"> 10,
<"B"> 20 default 10;
