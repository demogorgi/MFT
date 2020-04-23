# Aus Schritt 1.1
param sum_abs_unt := 10;
param sum_abs_kuz := 50;

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
<"A","C">,
<"B","C">,
<"C","B">,
<"D","E">,
<"E","D">,
<"A","D">,
<"D","A">,
<"C","E">,
<"E","C">
};

# Kapazitäten
param capl[E] :=
<"D","E"> 10 default 0;

param capu[E] :=
<"A","B"> 10,
<"B","A"> 100,
<"A","C"> 10,
<"B","C"> 100,
<"C","B"> 100,
<"D","E"> 20,
<"E","D"> 100,
<"A","D"> 10,
<"D","A"> 10,
<"C","E"> 100,
<"E","C"> 100;

param dist[E] :=
<"A","B"> 100,
<"B","A"> 100,
<"A","C"> 100,
<"B","C"> 100,
<"C","B"> 100,
<"D","E"> 100,
<"E","D"> 100,
<"A","D"> 100,
<"D","A"> 100,
<"C","E"> 100,
<"E","C"> 100;

# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"A"> -5,
<"B"> -0,
<"C"> -5,
<"D"> -0,
<"E"> -10;

# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"A"> 0,
<"B"> 0,
<"C"> 5,
<"D"> 10,
<"E"> 0;

# was kann unterbrochen werden
param ul[N] :=
<"A"> -5,
<"B"> -0,
<"C"> -5,
<"D"> -0,
<"E"> -10;

# was kann unterbrochen werden
param uu[N] :=
<"A"> 0,
<"B"> 0,
<"C"> 5,
<"D"> 10,
<"E"> 0;

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
<"A"> 50,
<"B"> -10,
<"C"> 20,
<"D"> 0,
<"E"> -100;
