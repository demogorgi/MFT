# Szenario: 111
# Beschreibung: BH ist FNB im Engpass, AH und CH sind voll austauschfähig und bilden eine gemeinsame Zone
# Erwartung: 
#   Unterbrechung von BH von 3 Exit 
#   Unterbrechung von AH von 2.5 (83%) Entry und CH von 0.5 Entry (17%) 
#   Aufteilung Kürzungen      : AH: 0, BH: 0, CH: 0

# Knoten
set N:= {
    <"AH">,
    <"BH">,
    <"CH">,
    <"D">,
    <"E">
};

# Kanten
set E := { <i,j> in N cross N with i != j };

# Kapazitäten
param capl[E] :=
<"AH","BH"> 0 default 0;

param capu[E] :=
<"AH","BH"> 100,
<"AH","CH"> 100,
<"BH","AH"> 7,
<"BH","CH"> 5,
<"CH","AH"> 100,
<"CH","BH"> 100 default 0;

param dist[E] :=
<"AH","BH"> 3,
<"AH","CH"> 4,
<"BH","AH"> 5,
<"BH","CH"> 6,
<"CH","AH"> 7,
<"CH","BH"> 8 default 100;

# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"AH"> -0.4 default -0.3;

# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"AH"> 0.5 default 0.25;

# was kann unterbrochen werden
param ul[N] :=
<"AH">   -50.0,
<"BH">   -40.0,
<"CH">   -10.0 default 0;

# was kann unterbrochen werden
param uu[N] :=
<"AH">   50.0,
<"BH">   40.0,
<"CH">   10.0 default 0;

# was kann gekuerzt werden
param zl[N] :=
<"AH"> -0.56,
<"BH"> -0.26,
<"CH"> -0.5 default 0;

# was kann gekuerzt werden
param zu[N] :=
<"AH"> 0.7,
<"BH"> 0.21,
<"CH"> 0.59 default 0;

##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param B[N] :=
<"AH"> 5,
<"BH"> 15,
<"CH"> -20 default 0;
