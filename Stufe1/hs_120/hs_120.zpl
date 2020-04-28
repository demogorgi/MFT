##### Modell: linMM

 ###### Szenario/ Variante: 120 TEST-120_H7

# Knoten
set N:= {
<"FGN">,
<"GNH">,
<"GSC">,
<"GTG_H">,
<"GTG_L">,
<"GUD_H">,
<"GUD_L">,
<"NOW_H">,
<"NOW_L">,
<"OGE_H">,
<"OGE_L">,
<"ONT_H">,
<"TG_H">,
<"bn">,
<"iNetz">,
<"tnbw_H">
};

# Kanten
set E := {# <i,j> in N cross N with i != j };
<"OGE_H","GSC">,
<"GSC","TG_H">,
<"GSC","NOW_L">,
<"GSC","GTG_H">,
<"GUD_H","GSC">,
<"GSC","GUD_H">,
<"GSC","ONT_H">,
<"GSC","tnbw_H">,
<"GSC","FGN">,
<"ONT_H","FGN">,
<"GSC","iNetz">,
<"ONT_H","iNetz">,
<"GSC","GNH">,
<"GUD_H","GNH">,
<"ONT_H","GSC">,
<"tnbw_H","GSC">,
<"GUD_H","GUD_L">,
<"GUD_H","NOW_H">,
<"GUD_H","OGE_H">,
<"GUD_H","ONT_H">,
<"GUD_H","TG_H">,
<"OGE_H","bn">,
<"OGE_H","GUD_H">,
<"OGE_H","NOW_H">,
<"OGE_H","OGE_L">,
<"OGE_H","TG_H">,
<"OGE_H","tnbw_H">,
<"tnbw_H","bn">,
<"tnbw_H","OGE_H">,
<"GTG_L","GUD_L">,
<"GTG_L","NOW_L">,
<"GUD_L","NOW_L">,
<"GUD_L","GTG_L">,
<"GUD_L","GUD_H">,
<"GUD_L","OGE_L">,
<"NOW_H","GUD_H">,
<"NOW_L","GTG_L">,
<"NOW_L","GUD_L">,
<"NOW_L","OGE_L">,
<"OGE_L","OGE_H">,
<"ONT_H","GUD_H">,
<"TG_H","OGE_H">,
<"TG_H","OGE_L">,
<"bn","tnbw_H">,
<"bn","OGE_H">,
<"GSC","OGE_H">
};

# Kapazit�ten
param capl[E] :=                
<"OGE_H","GSC"> 0.0 default 0;

param capu[E] :=
<"OGE_H","GSC"> 10.125,
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
<"GSC","OGE_H"> 14.625 default 0;


param dist[E] :=
<"OGE_H","GSC"> 100 default 100;
  
# was kann aus dem Puffer entnommen werden?
param pl[N] :=
<"GSC"> 0.0,
<"ONT_H"> 0.0,
<"GUD_H"> 0.0,
<"NOW_L"> 0.0,
<"GTG_L"> 0.0,
<"GUD_L"> 0.0,
<"OGE_H"> 0.0,
<"OGE_L"> 0.0,
<"TG_H"> 0.0,
<"bn"> 0.0,
<"tnbw_H"> 0.0,
<"NOW_H"> 0.0,
<"GTG_H"> 0.0 default 0;
  
# was kann in den Puffer gef�llt werden?
param pu[N] :=
<"GSC"> 0.0,
<"GUD_H"> 0.0,
<"OGE_H"> 0.0,
<"tnbw_H"> 0.0,
<"GTG_L"> 0.0,
<"GUD_L"> 0.0,
<"NOW_L"> 0.0,
<"OGE_L"> 0.0,
<"ONT_H"> 0.0,
<"TG_H"> 0.0,
<"bn"> 0.0,
<"NOW_H"> 0.0,
<"GTG_H"> 0.0 default 0;
  
# was kann unterbrochen werden
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
<"tnbw_H"> 0.0 default 0;
  
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
<"tnbw_H"> 0.0 default 0;
  
# was kann gekuerzt werden  (hier: Vorgabe der TVK fuer Ratio -> zu skalieren)
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
<"GTG_H"> 0.0 default 0;
  
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
<"GTG_H"> 0.0 default 0;
  
##################################################################################################
# Bedarfe (>0 �berdeckung, <0 Unterdeckung)
param B[N] :=
<"FGN"> 0.0,
<"GNH"> 0.0,
<"GSC"> 43.73,
<"GTG_H"> 0.0,
<"GTG_L"> 0.0,
<"GUD_H"> -7.6,
<"GUD_L"> 0.0,
<"NOW_H"> 0.0,
<"NOW_L"> 0.0,
<"OGE_H"> -4.35,
<"OGE_L"> 0.0,
<"ONT_H"> -15.24,
<"TG_H"> -5.3,
<"bn"> -9.01,
<"iNetz"> 0.0,
<"tnbw_H"> -7.77 default 0;
