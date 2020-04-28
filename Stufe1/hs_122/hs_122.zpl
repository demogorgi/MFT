##### Modell: linMM

 ###### Szenario/ Variante: hs_122
 #                          Mehrfachknoten bei OGE und GSC zur Abbildung paralleler Kanten integriert

# Knoten
set N:= {
<"FGN">,
<"GNH">,
<"GSC">,
<"GSC2">,
<"GTG_H">,
<"GTG_L">,
<"GUD_H">,
<"GUD_L">,
<"NOW_H">,
<"NOW_L">,
<"OGE_H">,
<"OGE_H2">,
<"OGE_L">,
<"ONT_H">,
<"TG_H">,
<"bn">,
<"iNetz">,
<"tnbw_H">
};

# Kanten
set E := { <i,j> in N cross N with i != j };

# Kostenkoeffizienten für Kantenflüsse: Kosten[i,j] = aF[i,j] * Fluss[i,j]
param aF[E]:=
<"GSC","TG_H"> 14.0,
<"GSC","NOW_L"> 11.0,
<"GSC","GTG_H"> 10.0,
<"GUD_H","GSC"> 9.0,
<"GSC","GUD_H"> 7.0,
<"GSC","ONT_H"> 4.0,
<"GSC","tnbw_H"> 15.0,
<"GSC","FGN"> 5.0,
<"ONT_H","FGN"> 4.0,
<"GSC","iNetz"> 6.0,
<"ONT_H","iNetz"> 6.0,
<"GSC","GNH"> 5.0,
<"GUD_H","GNH"> 5.0,
<"ONT_H","GSC"> 5.0,
<"tnbw_H","GSC"> 6.0,
<"GUD_H","GUD_L"> 5.0,
<"GUD_H","NOW_H"> 6.0,
<"GUD_H","OGE_H"> 10.0,
<"GUD_H","ONT_H"> 8.0,
<"GUD_H","TG_H"> 11.0,
<"OGE_H","bn"> 21.0,
<"OGE_H","GUD_H"> 4.0,
<"OGE_H","NOW_H"> 8.0,
<"OGE_H","OGE_L"> 6.0,
<"OGE_H","TG_H"> 7.0,
<"OGE_H","tnbw_H"> 26.0,
<"tnbw_H","bn"> 4.0,
<"tnbw_H","OGE_H"> 5.0,
<"GTG_L","GUD_L"> 4.0,
<"GTG_L","NOW_L"> 5.0,
<"GUD_L","NOW_L"> 6.0,
<"GUD_L","GTG_L"> 5.0,
<"GUD_L","GUD_H"> 4.0,
<"GUD_L","OGE_L"> 10.0,
<"NOW_H","GUD_H"> 4.0,
<"NOW_L","GTG_L"> 7.0,
<"NOW_L","GUD_L"> 8.0,
<"NOW_L","OGE_L"> 9.0,
<"OGE_L","OGE_H"> 3.0,
<"ONT_H","GUD_H"> 7.0,
<"TG_H","OGE_H"> 4.0,
<"TG_H","OGE_L"> 5.0,
<"bn","tnbw_H"> 5.0,
<"bn","OGE_H"> 4.0,
<"GSC","OGE_H"> 12.0,
<"OGE_H","GSC"> 5.0,
<"GSC2","OGE_H2"> 13.0,
<"OGE_H2","GSC2"> 16.0,
<"GSC2","GSC"> 1.0,
<"GSC","GSC2"> 1.0,
<"OGE_H","OGE_H2"> 1.0,
<"OGE_H2","OGE_H"> 1.0 default 2;

# Kostenkoeffizienten für Puffer: Kosten[i] = aB[i] * p[i]
param aB[N]:=
<"GSC"> 1 default 1;

# Kapazitäten
param capl[E] :=                
<"GSC","TG_H"> 0.0 default 0;

param capu[E] :=
<"GSC","TG_H"> 0.53,
<"GSC","NOW_L"> 1.4,
<"GSC","GTG_H"> 1.125,
<"GUD_H","GSC"> 16.0,
<"GSC","GUD_H"> 16.0,
<"GSC","ONT_H"> 40.0,
<"GSC","tnbw_H"> 3.6180000000000003,
<"GSC","FGN"> 5.4,
<"ONT_H","FGN"> 3.0555380000000003,
<"GSC","iNetz"> 2.0313,
<"ONT_H","iNetz"> 2.497647,
<"GSC","GNH"> 7.2,
<"GUD_H","GNH"> 3.7,
<"ONT_H","GSC"> 0.0,
<"tnbw_H","GSC"> 0.0,
<"GUD_H","GUD_L"> 1.0,
<"GUD_H","NOW_H"> 1.0,
<"GUD_H","OGE_H"> 6.5,
<"GUD_H","ONT_H"> 18.6,
<"GUD_H","TG_H"> 4.18875,
<"OGE_H","bn"> 23.61,
<"OGE_H","GUD_H"> 16.0,
<"OGE_H","NOW_H"> 0.0,
<"OGE_H","OGE_L"> 0.2,
<"OGE_H","TG_H"> 13.442662,
<"OGE_H","tnbw_H"> 22.1,
<"tnbw_H","bn"> 0.5,
<"tnbw_H","OGE_H"> 0.0,
<"GTG_L","GUD_L"> 0.0,
<"GTG_L","NOW_L"> 0.0,
<"GUD_L","NOW_L"> 2.2,
<"GUD_L","GTG_L"> 4.109454,
<"GUD_L","GUD_H"> 0.0,
<"GUD_L","OGE_L"> 2.3,
<"NOW_H","GUD_H"> 1.0,
<"NOW_L","GTG_L"> 2.0,
<"NOW_L","GUD_L"> 2.0,
<"NOW_L","OGE_L"> 0.6,
<"OGE_L","OGE_H"> 2.5,
<"ONT_H","GUD_H"> 5.622999999999999,
<"TG_H","OGE_H"> 5.0,
<"TG_H","OGE_L"> 0.2,
<"bn","tnbw_H"> 2.17,
<"bn","OGE_H"> 10.635,
<"GSC","OGE_H"> 14.625,
<"OGE_H","GSC"> 10.125,
<"GSC2","OGE_H2"> 3.6,
<"OGE_H2","GSC2"> 1.125,
<"GSC2","GSC"> 300.0,
<"GSC","GSC2"> 300.0,
<"OGE_H","OGE_H2"> 300.0,
<"OGE_H2","OGE_H"> 300.0 default 0;


param dist[E] :=
<"GSC","TG_H"> 100 default 100;
  
# was kann aus dem Puffer entnommen werden? pl <= 0
param pl[N] :=
<"GSC"> 0.0,
<"ONT_H"> 0.0,
<"GUD_H"> 0.0,
<"NOW_L"> -1.0,
<"GTG_L"> -1.0,
<"GUD_L"> -1.0,
<"OGE_H"> 0.0,
<"OGE_L"> -1.0,
<"TG_H"> 0.0,
<"bn"> 0.0,
<"tnbw_H"> 0.0,
<"NOW_H"> 0.0,
<"GTG_H"> 0.0,
<"GSC2"> 0.0,
<"OGE_H2"> 0.0 default 0;
  
# was kann in den Puffer gefüllt werden?
param pu[N] :=
<"GSC"> 1.0,
<"GUD_H"> 1.0,
<"OGE_H"> 1.0,
<"tnbw_H"> 1.0,
<"GTG_L"> 1.0,
<"GUD_L"> 1.0,
<"NOW_L"> 1.0,
<"OGE_L"> 1.0,
<"ONT_H"> 1.0,
<"TG_H"> 1.0,
<"bn"> 1.0,
<"NOW_H"> 1.0,
<"GTG_H"> 1.0,
<"GSC2"> 0.0,
<"OGE_H2"> 0.0 default 0;
  
# was kann unterbrochen werden ul <= 0
param ul[N] :=
<"bn"> 0.0,
<"GSC"> 0.0,
<"GTG_H"> 0.0,
<"GTG_L"> 0.0,
<"GUD_H"> 0.0,
<"GUD_L"> 0.0,
<"NOW_H"> 0.0,
<"NOW_L"> 0.0,
<"OGE_H"> 0.0,
<"OGE_L"> 0.0,
<"ONT_H"> 0.0,
<"TG_H"> 0.0,
<"tnbw_H"> 0.0,
<"GSC2"> 0.0,
<"OGE_H2"> 0.0 default 0;
  
# was kann unterbrochen werden
param uu[N] :=
<"bn"> 0.0,
<"GSC"> 0.0,
<"GTG_H"> 0.0,
<"GTG_L"> 0.0,
<"GUD_H"> 0.0,
<"GUD_L"> 0.0,
<"NOW_H"> 0.0,
<"NOW_L"> 0.0,
<"OGE_H"> 0.0,
<"OGE_L"> 0.0,
<"ONT_H"> 0.0,
<"TG_H"> 0.0,
<"tnbw_H"> 0.0,
<"GSC2"> 0.0,
<"OGE_H2"> 0.0 default 0;
  
# was kann gekuerzt werden  (hier: Vorgabe der TVK fuer Ratio -> zu skalieren) zl <= 0
param zl[N] :=
<"GSC"> -120.154,
<"GUD_H"> -23.985,
<"OGE_H"> -80.666,
<"tnbw_H"> -2.946,
<"FGN"> 0.0,
<"GTG_L"> -4.93,
<"GUD_L"> -5.78,
<"GNH"> 0.0,
<"iNetz"> 0.0,
<"NOW_L"> -4.581,
<"OGE_L"> -5.561,
<"ONT_H"> -41.273999999999994,
<"TG_H"> -2.9589999999999996,
<"bn"> -35.594,
<"NOW_H"> 0.0,
<"GTG_H"> 0.0,
<"GSC2"> 0.0,
<"OGE_H2"> 0.0 default 0;
  
# was kann gekuerzt werden (hier: Vorgabe der TVK fuer Ratio -> zu skalieren)
param zu[N] :=
<"GSC"> 113.066,
<"FGN"> 0.0,
<"iNetz"> 0.0,
<"GNH"> 0.0,
<"ONT_H"> 55.063,
<"bn"> 25.058000000000003,
<"GTG_L"> 15.054,
<"GUD_H"> 60.301,
<"GUD_L"> 9.65,
<"NOW_L"> 9.36,
<"OGE_H"> 119.181,
<"OGE_L"> 25.824,
<"TG_H"> 30.269000000000002,
<"tnbw_H"> 1.4269999999999998,
<"NOW_H"> 0.0,
<"GTG_H"> 0.0,
<"GSC2"> 0.0,
<"OGE_H2"> 0.0 default 0;
  
##################################################################################################
# Bedarfe (>0 Überdeckung, <0 Unterdeckung)
param B[N] :=
<"FGN"> 0.0,
<"GNH"> 0.0,
<"GSC"> 43.73,
<"GSC2"> 0.0,
<"GTG_H"> 0.0,
<"GTG_L"> 0.0,
<"GUD_H"> -7.6,
<"GUD_L"> 0.0,
<"NOW_H"> 0.0,
<"NOW_L"> 0.0,
<"OGE_H"> -4.35,
<"OGE_H2"> 0.0,
<"OGE_L"> 0.0,
<"ONT_H"> -15.24,
<"TG_H"> -5.3,
<"bn"> -9.01,
<"iNetz"> 0.0,
<"tnbw_H"> -7.8 default 0;
