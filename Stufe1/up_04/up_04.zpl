# 4. Szenario:
#
# Vorgaben:
# Alle Pufferpotentiale = 0
# Alle M<>M Kanten nicht restriktiv: 0-> 1000.000.000
# Bilanzen der NBZ:                A = +200.000.000,        B = -100.000.000,        C =             0            (Summe = 100.000.000)
# M>U Potentiale der NBZ:          A =   90.000.000,        B =    5.000.000,        C =     4.000.000            (Summe =  99.000.000)
# M>Z Potentiale der NBZ:          A =   10.000.000,        B =   10.000.000,        C =    20.000.000            (Summe =  40.000.000)
#
# Erwartetes Ergebnis:
# Die Summe der Bilanz verteilt 99.000.000 auf die verfügbaren M>U Potentiale.
# Die verbleibenden 1.000.000 verteilen sich im Ratio der M>Z Potentiale ( A= 250.000, B= 250.000, C= 500.000)

# Knoten
set N:= {
    <"A">,
    <"B">,
    <"C">,
    <"D">,
    <"E">
};

# Kanten
set E := { <i,j> in N cross N with i != j };

# Kapazitäten
param capl[E] :=
<"A","B"> 0 default 0;

param capu[E] :=
<"A","B"> 1000 default 1000;

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
<"A">  -90,
<"B">   -5,
<"C">   -4 default 0;

# was kann unterbrochen werden
param uu[N] :=
<"A"> 0 default 0;

# was kann gekuerzt werden
param zl[N] :=
<"A"> -10,
<"B"> -10,
<"C"> -20 default 0;

# was kann gekuerzt werden
param zu[N] :=
<"A"> 0 default 0;

##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param B[N] :=
<"A"> 200,
<"B"> -100 default 0;
