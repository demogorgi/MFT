
# Maximal auftretende Kantenlänge
param dmax := max <i, j> in E : dist[i, j];

# Mittelpunkt des Intervalls [a, b]
defnumb m(a, b) := a + ( b - a ) / 2;

# Polynom 2. Grades (Scheitelpunktform) wird für Kostenfunktionen verwendet. Scheitelpunkt ist S(d|e).
defnumb h(x, a, d, e) := a * ( x - d ) ** 2 + e;

# Berechnung Position des k-ten Linearisierungsknotens
defnumb getKnot(k, lb, ub, numIntervals) := if k == 0 then lb else lb + k * ( ub - lb ) / numIntervals end;

# Berechnung der Steigung des k-ten Linearitätsbereichs
defnumb getSlope(knotkminus1, knotk, a, d, e) := if knotk == knotkminus1 then 0 else ( h(knotk, a, d, e) - h(knotkminus1, a, d, e) ) / ( knotk - knotkminus1 ) end;

# Intervallanzahlen für Linearisierungen
param numIntervalsF := 2500;
param numIntervalsB := 2500;
param numIntervalsD := 2500;
# Normale Kantenflüsse: Koeffizienten für Parabel zwischen capl und capu mit Scheitelpunkt (capl, 0) und Maximum cm bei capu.
param cm := 1;
param dF[<i, j> in E] := capl[i, j];
param eF[<i, j> in E] := 0;
param aF[<i, j> in E] := if capu[i,j] == capl[i,j] then 0 else dist[i,j] / dmax * cm / ( capu[i, j] - capl[i, j] ) ** 2 end;
# Pufferbewirtschaftung: Koeffizienten für Parabel zwischen pl und pu mit Scheitelpunkt (pl+(pu-pl)/2, 0)).
# 5% der Abweichung von der maximalen Abweichung in eine Richtung Kosten 1. 10% kosten 4.
param dB[<i> in N] := m(pl[i], pu[i]);
param eB[<i> in N] := 0;
param aB[<i> in N] := if pu[i] == pl[i] then 0 else 1 / ( 0.5 * ( pu[i] - pl[i] ) / 2 ) ** 2 end;
# Abweichung vom gemeinsamem Ratio
param dD := 0;
param eD := 0;
param aD := 100;

# Modellierung Kantenkosten
# Anzahl der Linearitätsbereiche
set knotIndicesF := { 0 .. numIntervalsF };
# Äquidistante Zerlegung von capl[i, j] bis capu[i, j]
param knotsF[<i, j, k> in E * knotIndicesF] := getKnot(k, capl[i, j], capu[i, j], numIntervalsF);
param slopeF[<i, j, k> in E * { 1 .. numIntervalsF }] := getSlope(knotsF[i, j, k-1], knotsF[i, j, k], aF[i, j], dF[i, j], eF[i, j]);
## Big-M für Modellierung paralleler Kanten. Hier wird der maximale Linearisierungswert von F[i,j] an der Stelle 0 berechnet.
#param bigMF[<i,j> in E] := max <k> in { 1 .. numIntervalsF }: ( slopeF[i, j, k] * ( 0 - knotsF[i, j, k] ) + h(knotsF[i, j, k], aF[i, j], dF[i, j], eF[i, j]) );
## Nur stdout
#do forall <i,j> in E do print "big-M[", i, ",", j, "]:", bigMF[i,j];
#do print "---------> knotsF:";
#do forall <i, j, k> in E * knotIndicesF do print knotsF[i, j, k];
#do print "---------> InfoF1: (knotsF[k-1], h(knotsF[k-1])), (knotsF[k], h(knotsF[k])), slopeF"; 
#do forall <i, j, k> in E * { 1 .. numIntervalsF } do print "(", knotsF[i, j, k-1], ", ", h(knotsF[i, j, k-1], aF[i, j], dF[i, j], eF[i,j]), "), (", knotsF[i, j, k], ", ", h(knotsF[i, j, k], aF[i, j], dF[i, j], eF[i,j]), "), ", slopeF[i, j, k];  
#do print "---------> Linearisierung:";
#do forall <i, j, k> in E * { 1 .. numIntervalsF } do print slopeF[i, j, k], " * ( x - ", knotsF[i, j, k], " ) + ", h(knotsF[i, j, k], aF[i, j], dF[i, j], eF[i,j]);
#do print "---------> InfoF:";
#do forall <i, j> in E do print "cap: [", capl[i, j], ", ", capu[i, j], "], d/dmax: ", dist[i, j] / dmax;
do print "(*-flow----> Originalfunktion:*)";
do print "Plot[{";
do forall <i, j> in E do print "(*", i, "->", j, "*)Piecewise[{{", aF[i,j], "* ( x - (", dF[i,j], ") )^2 + ", eF[i,j], ", ", capl[i,j], " <= x <= ", capu[i,j], "}, Nothing}],";
do print "}, {x, 0, 100}]";

# Modellierung Pufferkosten
# Anzahl der Linearitätsbereiche
set knotIndicesB := { 0 .. numIntervalsB };
# Äquidistante Zerlegung von pl[i] bis pu[i]
param knotsB[<i, k> in N * knotIndicesB] := getKnot(k, pl[i], pu[i], numIntervalsB);
param slopeB[<i, k> in N * { 1 .. numIntervalsB }] := getSlope(knotsB[i, k-1], knotsB[i, k], aB[i], dB[i], eB[i]);
## Big-M für Modellierung keine Kosten bei optimaler Puffernutzung
#param bigMB[<i> in N] := h(pl[i], aB[i], dB[i], eB[i]);
## Nur stdout
#do forall <i> in N do print "bigMB: ", bigMB[i];
#do print "---------> knotsB:";
#do forall <i, k> in N * knotIndicesB do print knotsB[i, k];
#do print "---------> InfoB: (knotsB[k-1], h(knotsB[k-1])), (knotsB[k], h(knotsB[k])), slopeB"; 
#do forall <i, k> in N * { 1 .. numIntervalsB } do print "(", knotsB[i, k-1], ", ", h(knotsB[i, k-1], aB[i], dB[i], eB[i]), "), (", knotsB[i, k], ", ", h(knotsB[i, k], aB[i], dB[i], eB[i]), "), ", slopeB[i, k];  
#do print "---------> Linearisierung:";
#do forall <i, k> in N * { 1 .. numIntervalsB } do print slopeB[i, k], " * ( x - ", knotsB[i, k], " ) + ", h(knotsB[i, k], aB[i], dB[i], eB[i]);
do print "(*-buf-----> Originalfunktion:*)";
do print "Plot[{";
do forall <i> in N do print "(*", i, "*)Piecewise[{{", aB[i], "* ( x - (", dB[i], ") )^2 + ", eB[i], ", ", pl[i], " <= x <= ", pu[i], "}, Nothing}],";
do print "}, {x, 0, 100}]";

# Modellierung Kosten Abweichung vom gemeinsamen Ratio
# Anzahl der Linearitätsbereiche
set knotIndicesD := { 0 .. numIntervalsD };
# Äquidistante Zerlegung von -1 bis 1
param knotsD[<k> in knotIndicesD] := getKnot(k, -1, 1, numIntervalsD);
#param knotsD[<k> in knotIndicesD] := getKnot2(k, aD, dD, eD, eD, wmax, numIntervalsD); 
param slopeD[<k> in { 1 .. numIntervalsD }] := getSlope(knotsD[k-1], knotsD[k], aD, dD, eD);
## Big-M für Modellierung keine Kosten bei optimalem Ratio
#param bigMD := h(-1, aD, dD, eD);
# Nur stdout
do print "---------> knotsD:";
do forall <k> in knotIndicesD do print knotsD[k];
do print "---------> InfoD: (knotsD[k-1], h(knotsD[k-1])), (knotsD[k], h(knotsD[k])), slopeD"; 
do forall <k> in { 1 .. numIntervalsD } do print "(", knotsD[k-1], ", ", h(knotsD[k-1], aD, dD, eD), "), (", knotsD[k], ", ", h(knotsD[k], aD, dD, eD), "), ", slopeD[k];  
do print "---------> Linearisierung:";
do forall <k> in { 1 .. numIntervalsD } do print slopeD[k], " * ( x - ", knotsD[k], " ) + ", h(knotsD[k], aD, dD, eD);
do print "(*-dev-----> Originalfunktion:*)";
do print "Plot[";
do print "Piecewise[{{", aD, "* ( x - (", dD, ") )^2 + ", eD, ", ", -1, " <= x <= ", 1, "}, Nothing}],";
do print " {x,-1,1}]";

#########################################################################
## Ausgabe
# Hier wird ein Ruby-Programm ausgegeben, mit dem hinterher eine Graphviz-Datei (http://graphviz.org/) erzeugt wird, die dann per dot das Ergebnis darstellt.
do print '-RUBY-class Numeric';
do print '-RUBY-   def go';
do print '-RUBY-       if self == 0';
do print '-RUBY-           1.0';
do print '-RUBY-       else';
do print '-RUBY-           self.abs == self ? s = 1.0 : s = -1.0';
do print '-RUBY-           s * 10.0 ** (Math.log10(self.abs).floor)';
do print '-RUBY-       end';
do print '-RUBY-   end';
do print '-RUBY-   def sig_round(d=0)';
do print '-RUBY-       self.abs() < 1e-06 ? 0.0 : self';
do print '-RUBY-       i = self.to_f';
do print '-RUBY-       if d == 0';
do print '-RUBY-           i.round';
do print '-RUBY-       else';
do print '-RUBY-           (((i / i.go * 10.0**d).round)/10.0**d)*i.go';
do print '-RUBY-       end';
do print '-RUBY-   end';
do print '-RUBY-   def signif(d=4)';
do print '-RUBY-       i = self.to_f';
do print '-RUBY-       if (i - i.to_i).abs() < 0.00001';
do print '-RUBY-           return i.to_i';
do print '-RUBY-       else';
do print '-RUBY-           Float("%.#{d}g" % i)';
do print '-RUBY-       end';
do print '-RUBY-   end';
do print '-RUBY-end';
do print '-RUBY-';
do print '-RUBY-def nullen(x)';
do print '-RUBY-   if x.nil?';
do print '-RUBY-        0.0';
do print '-RUBY-   else';
do print '-RUBY-        x.match(/[\d.]+/)[0]';
do print '-RUBY-   end';
do print '-RUBY-end';
do print '-RUBY-';
do print '-RUBY-flow = {}';
do print '-RUBY-cost = {}';
do print '-RUBY-buffer = {}';
do print '-RUBY-cbuffer = {}';
do print '-RUBY-interrupt = {}';
do print '-RUBY-cinterrupt = {}';
do print '-RUBY-curtail = {}';
do print '-RUBY-ccurtail = {}';
#
do print '-RUBY-FlowSolution = File.open(ARGV[0]).grep(/^f\$/)';
do print '-RUBY-if FlowSolution != []';
#do print '-RUBY-    puts(FlowSolution)';
do print '-RUBY-    FlowSolution.each{|x| flow[x.match(/^f\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Fluesse: ")';
do print '-RUBY-puts(flow)';
#
do print '-RUBY-CostSolution = File.open(ARGV[0]).grep(/^cf\$/)';
do print '-RUBY-if CostSolution != []';
#do print '-RUBY-    puts(CostSolution)';
do print '-RUBY-    CostSolution.each{|x| cost[x.match(/^cf\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Flusskosten: ")';
do print '-RUBY-puts(cost)';
#
do print '-RUBY-BufferSolution = File.open(ARGV[0]).grep(/^p\$/)';
do print '-RUBY-if BufferSolution != []';
#do print '-RUBY-    puts(BufferSolution)';
do print '-RUBY-    BufferSolution.each{|x| buffer[x.match(/^p\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Puffernutzung: ")';
do print '-RUBY-puts(buffer)';
#
do print '-RUBY-BufferCostSolution = File.open(ARGV[0]).grep(/^cp\$/)';
do print '-RUBY-if BufferCostSolution != []';
#do print '-RUBY-    puts(BufferCostSolution)';
do print '-RUBY-BufferCostSolution.each{|x| cbuffer[x.match(/^cp\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Pufferkosten: ")';
do print '-RUBY-puts(cbuffer)';
#
do print '-RUBY-InterruptSolution = File.open(ARGV[0]).grep(/^u\$/)';
do print '-RUBY-if InterruptSolution != []';
#do print '-RUBY-    puts(InterruptSolution)';
do print '-RUBY-    InterruptSolution.each{|x| interrupt[x.match(/^u\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Unterbrechung: ")';
do print '-RUBY-puts(interrupt)';
#
do print '-RUBY-InterruptCostSolution = File.open(ARGV[0]).grep(/^cru\$/)';
do print '-RUBY-if InterruptCostSolution != []';
#do print '-RUBY-puts(InterruptCostSolution)';
do print '-RUBY-    InterruptCostSolution.each{|x| cinterrupt[x.match(/^cru\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Unterbrechungskosten: ")';
do print '-RUBY-puts(cinterrupt)';
#
do print '-RUBY-CurtailSolution = File.open(ARGV[0]).grep(/^z\$/)';
do print '-RUBY-if CurtailSolution != []';
#do print '-RUBY-    puts(CurtailSolution)';
do print '-RUBY-    CurtailSolution.each{|x| curtail[x.match(/^z\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Kuerzung: ")';
do print '-RUBY-puts(curtail)';
#
do print '-RUBY-CurtailCostSolution = File.open(ARGV[0]).grep(/^crz\$/)';
do print '-RUBY-if CurtailCostSolution != []';
#do print '-RUBY-    puts(CurtailCostSolution)';
do print '-RUBY-    CurtailCostSolution.each{|x| ccurtail[x.match(/^crz\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Kuerzungskosten: ")';
do print '-RUBY-puts(ccurtail)';
#
#
do print '-RUBY-dotFile = ""';
do print '-RUBY-dotFile << "digraph mgko {\n"';
do print '-RUBY-dotFile << "              graph [ fontsize=10, ratio=1.25 ]\n"';
do print '-RUBY-dotFile << "              node [ fontsize=12, style = filled ]\n"';
do print '-RUBY-dotFile << "              edge [ color = ', '\"', "#", '687466\"  fontcolor=', '\"', "#", '084177\"', ' fontsize=10 ]\n"';
do print '-RUBY-dotFile << "\nnode [shape = box, fixedsize = false, fontcolor = ', '\"', "#", '084177\"', ' color = ', '\"', "#", '687466\"', '];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'f0f0f0\" ];\n"';
do forall <n> in N with B[n] == 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'cd8d7b\" ];\n"';
do forall <n> in N with B[n] > 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'fbc490\" ];\n"';
do forall <n> in N with B[n] <  0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})", '\"];\n"';
#
# FNB
do forall <i, j> in E do print '-RUBY-dotFile << "', i, '->', j, ' [ label = \"', "(#", '{cost["', i, '->', j, '"].to_f.signif()})', "\\nA: #{", dist[i,j], ".to_f.signif(1)}/#{", dmax, ".to_f.signif(1)} = #{", dist[i,j]/dmax, '.signif(1)}', "\\n#", '{flow["', i, '->', j, '"].to_f.signif()} in [', "#", '{', capl[i, j], '.signif()}', ", #", '{', capu[i, j], ".signif()}]", '\" ]\n"';
do print '-RUBY-dotFile << "\noverlap = false\n"';
do print '-RUBY-dotFile << "\nlabeljust=left"';
do print '-RUBY-dotFile << "\n}"';
do print '-RUBY-File.write(ARGV[0] + ".dot", dotFile)';
do print '-RUBY-system("dot -Tpng -Gdpi=500 #{ARGV[0]}.dot > #{ARGV[0]}.png")';
###########################################################

### Variablen
# Kantenflussvariablen
var f[E] real >= 0;
var cf[E] real >= 0;
# Puffernutzung
var p[N] real >= -infinity;
var cp[N] real >= 0;
#
# Unterbrechungsmodell
var u[N] real >= -infinity;
var unt_pos[N] real >= 0;
var unt_neg[N] real >= 0;
var unt_abs[N] real >= 0;
var cru[N] real >= 0;
# Kürzungsmodell
var z[N] real >= -infinity;
var kuz_pos[N] real >= 0;
var kuz_neg[N] real >= 0;
var kuz_abs[N] real >= 0;
var crz[N] real >= 0;

# Unterbrechungsratio
var Ru real >= 0 <= 1;
var x[N] real >= -1 <= 1;
# Kürzungsratio
var Rz real >= 0 <= 1;
var y[N] real >= -1 <= 1;

### Zielfunktion
# Minimiere Kosten
minimize obj: sum <i,j> in E: cf[i,j] + sum <n> in N: cp[n] + sum <n> in N: cru[n] + sum <n> in N: crz[n];

### Nebenbedingungen
# Konvexe Kosten für Fluss
subto convexCostsFlow:
      forall <i, j, k> in E * { 1 .. numIntervalsF }: cf[i, j] >= slopeF[i, j, k] * ( f[i, j] - knotsF[i, j, k] ) + h(knotsF[i, j, k], aF[i, j], dF[i, j], eF[i,j]);
# Konvexe Kosten für Puffer
subto convexCostsBuffer:
      forall <i, k> in N * { 1 .. numIntervalsB }: cp[i] >= slopeB[i, k] * ( p[i] - knotsB[i, k] ) + h(knotsB[i, k], aB[i], dB[i], eB[i]);
# Konvexe Kosten Ratioabweichung Unterbrechung
subto convexCostsURatio:
      forall <i, k> in N * { 1 .. numIntervalsD }: cru[i] >= slopeD[k] * ( x[i] - knotsD[k] ) + h(knotsD[k], aD, dD, eD);
# Konvexe Kosten Ratioabweichung Kuerzung
subto convexCostsZRatio:
      forall <i, k> in N * { 1 .. numIntervalsD }: crz[i] >= slopeD[k] * ( y[i] - knotsD[k] ) + h(knotsD[k], aD, dD, eD);


# Unterbrechungen
# u < 0 -> Entryunterbrechung
# u > 0 -> Exitunterbrechung
# Betrag der Unterbrechung
subto uabs1:
      forall <n> in N: u[n] == unt_pos[n] - unt_neg[n];
subto uabs2:
      forall <n> in N: unt_abs[n] == unt_pos[n] + unt_neg[n];

# Kürzingen
# k < 0 -> Entrykürzung
# k > 0 -> Exitkürzung
# Betrag der Kürzungen
subto kabs1:
      forall <n> in N: z[n] == kuz_pos[n] - kuz_neg[n];
subto kabs2:
      forall <n> in N: kuz_abs[n] == kuz_pos[n] + kuz_neg[n];

# Netzpuffernutzung
# p < 0 -> Befüllung des Puffers
# p > 0 -> Entnahme aus dem Puffer
subto puffergrenzen:
      forall <n> in N: pl[n] <= p[n] <= pu[n];
#
subto unterbrechungsgrenzen:
      forall <n> in N: ul[n] <= u[n] <= uu[n];
subto unterbrechungsbetragssumme:
      sum_abs_unt == sum <n> in N: unt_abs[n];

subto unterbrechungsratio1:
      forall <n> in N do if ul[n] < 0 and uu[n] > 0 then - unt_neg[n]/ul[n] + unt_pos[n]/uu[n] + x[n] == Ru end;
subto unterbrechungsratio2:
      forall <n> in N do if ul[n] == 0 and uu[n] > 0 then unt_pos[n]/uu[n] + x[n] == Ru end;
subto unterbrechungsratio3:
      forall <n> in N do if ul[n] < 0 and uu[n] == 0 then - unt_neg[n]/ul[n] + x[n] == Ru end;
subto unterbrechungsratio4:
      forall <n> in N do if ul[n] == 0 and uu[n] == 0 then unt_neg[n] + unt_pos[n] == 0 end;
#
#
#subto kuerzungsgrenzen:
#      forall <n> in N: zl[n] <= z[n] <= zu[n];
subto kuerzungsbetragssumme:
      sum_abs_kuz == sum <n> in N: kuz_abs[n];

subto kuerzungsratio1:
      forall <n> in N do if zl[n] < 0 and zu[n] > 0 then - kuz_neg[n]/zl[n] + kuz_pos[n]/zu[n] + y[n] == Rz end;
subto kuerzungsratio2:
      forall <n> in N do if zl[n] == 0 and zu[n] > 0 then kuz_pos[n]/zu[n] + y[n] == Rz end;
subto kuerzungsratio3:
      forall <n> in N do if zl[n] < 0 and zu[n] == 0 then - kuz_neg[n]/zl[n] + y[n] == Rz end;
subto kuerzungsratio4:
      forall <n> in N do if zl[n] == 0 and zu[n] == 0 then kuz_neg[n] + kuz_pos[n] == 0 end;

# Am Ende müssen alle Knoten ausgeglichen sein
subto flussbilanz:
      # Zufluss - Abfluss + Puffer + Unterbrechung + Kürzung = - Bilanz (Bilanz>0 Überdeckung, <0 Unterdeckung)
      forall <n> in N: sum <i, n> in E: f[i, n] - sum <n, i> in E: f[n, i] + p[n] + u[n] + z[n] == - B[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto kantenkapa:
      forall <i, j> in E: capl[i, j] <= f[i, j] <= capu[i, j];

