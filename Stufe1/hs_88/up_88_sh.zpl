# Szenario: 88 (Test C)
# Erwartung: 
#   Aufteilung Unterbrechungen: GSC: 50%, GUD: 25%, ONT: 25%  (0.5, 0.25, 0.25)
#   Aufteilung Kürzungen      : GSC: 64%, GUD: 30%, ONT: 6%   (5.8, 2.7 , 0.5)

# Knoten
set N:= {
    <"GSC">,
    <"GUD">,
    <"ONT">,
    <"D">,
    <"E">
};

# Kanten
set E := { <i,j> in N cross N with i != j };

# Kapazitäten
param capl[E] :=
<"GSC","GUD"> 0 default 0;

param capu[E] :=
<"GSC","GUD"> 16,
<"GSC","ONT"> 40,
<"GUD","GSC"> 7,
<"GUD","ONT"> 19,
<"ONT","GUD"> 10 default 0;

param dist[E] :=
<"GSC","GUD"> 100 default 100;

# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"GSC"> 0 default 0;

# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"GSC"> 0 default 0;

# was kann unterbrochen werden
param ul[N] :=
<"GSC">   -0.5,
<"GUD">   -0.25,
<"ONT">   -0.25 default 0;

# was kann unterbrochen werden
param uu[N] :=
<"GSC">   0.5,
<"GUD">   0.25,
<"ONT">   0.25 default 0;

# was kann gekuerzt werden
param zl[N] :=
<"GSC"> -56,
<"GUD"> -26,
<"ONT"> -5 default 0;

# was kann gekuerzt werden
param zu[N] :=
<"GSC"> 7,
<"GUD"> 21,
<"ONT"> 59 default 0;

##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param B[N] :=
<"GSC"> 10,
<"GUD"> -10,
<"ONT"> 10 default 0;
