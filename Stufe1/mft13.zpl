# Maximal auftretender Kantenaufwand
param dmax := max <i, j> in E : dist[i, j];

# Normale Kantenflüsse: aF = Koeffizienten für Parabel zwischen capl und capu mit Scheitelpunkt (capl, 0) und Maximum dist / dmax bei capu.
param aF[<i, j> in E] := if capu[i,j] == capl[i,j] then 0 else ( dist[i,j] / dmax ) / ( capu[i, j] - capl[i, j] ) ** 2 end;

### Variablen
# Kantenflussvariablen
var f[E] real >= 0;
var cf[E] real >= 0;
# Puffernutzung
var p[N] real >= -infinity;
# Unterbrechungsmodell
var u[N] real >= -infinity;
# Kürzungsmodell
var z[N] real >= -infinity;
# Slackmodell
var Z[N] >= -infinity;

### Zielfunktion
# Minimiere Kosten
minimize obj: sum <i,j> in E: cf[i,j];

### Nebenbedingungen
# Quadratische Kosten für Fluss
subto quadraticCostsFlow:
      #forall <i, j> in E: cf[i, j] >= aF[i,j] * ( f[i, j]^2 - 2 * f[i,j] * capl[i,j] + capl[i,j] * capl[i,j] );
      forall <i, j> in E: cf[i, j] >= aF[i,j] * ( f[i, j] - capl[i,j] )^2;

# Kann in Mathematica genutzt werden, um die Kostenfunktionen zu plotten. Hinter der jeweils letzten Funktion muss ein "," entfernt werden.
# Und "e-06" etc. muss ersetzt werden durch "*^-6".
do print "(*Kantenkosten*)Plot[{";
do forall <i, j> in E do print "(*", i, "->", j, "*)Piecewise[{{", aF[i,j], " * ( f - ", capl[i,j], " )^2 ,", capl[i,j], " <= f <= ", capu[i,j], "}, Nothing}],";
do print "}, {f, 0, ", max <i,j> in E: capu[i,j], "}, PlotRange -> All]";

# Fixierungen aus Schritt 1.2
subto fixp:
      forall <n> in N: p[n] == fix_p[n];
subto fixu:
      forall <n> in N: u[n] == fix_u[n];
subto fixz:
      forall <n> in N: z[n] == fix_z[n];
subto fixZ:
      forall <n> in N: Z[n] == fix_Z[n];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flussbilanz:
      # Zufluss - Abfluss + Puffer + Unterbrechung + Kürzung = - Bilanz (Bilanz>0 Überdeckung, <0 Unterdeckung)
      forall <n> in N: sum <i, n> in E: f[i, n] - sum <n, i> in E: f[n, i] + p[n] + u[n] + z[n] + Z[n] == - B[n];

# Kapazitätsgrenzen müssen eingehalten werden
subto kantenkapa:
      forall <i, j> in E: capl[i, j] <= f[i, j] <= capu[i, j];

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
do print '-RUBY-slack = {}';
do print '-RUBY-cslack = {}';
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
do print '-RUBY-BufferCostSolution = File.open(ARGV[0]).grep(/^crp\$/)';
do print '-RUBY-if BufferCostSolution != []';
#do print '-RUBY-    puts(BufferCostSolution)';
do print '-RUBY-BufferCostSolution.each{|x| cbuffer[x.match(/^crp\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
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
do print '-RUBY-SlackSolution = File.open(ARGV[0]).grep(/^Z\$/)';
do print '-RUBY-if SlackSolution != []';
do print '-RUBY-    puts(SlackSolution)';
do print '-RUBY-    SlackSolution.each{|x| slack[x.match(/^Z\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Slack: ")';
do print '-RUBY-puts(slack)';
#
do print '-RUBY-SlackCostSolution = File.open(ARGV[0]).grep(/^crZ\$/)';
do print '-RUBY-if SlackCostSolution != []';
do print '-RUBY-    puts(SlackCostSolution)';
do print '-RUBY-    SlackCostSolution.each{|x| cslack[x.match(/^crZ\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Slackkosten: ")';
do print '-RUBY-puts(cslack)';
#
do print '-RUBY-dotFile = ""';
do print '-RUBY-dotFile << "digraph mgko {\n"';
do print '-RUBY-dotFile << "              graph [ fontsize=10, ratio=1.25 ]\n"';
do print '-RUBY-dotFile << "              node [ fontsize=12, style = filled ]\n"';
do print '-RUBY-dotFile << "              edge [ color = ', '\"', "#", '687466\"  fontcolor=', '\"', "#", '084177\"', ' fontsize=10 ]\n"';
do print '-RUBY-dotFile << "\nnode [shape = box, fixedsize = false, fontcolor = ', '\"', "#", '084177\"', ' color = ', '\"', "#", '687466\"', '];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'f0f0f0\" ];\n"';
do forall <n> in N with B[n] == 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})\\nZ: #{slack['", n, "'].to_f.signif()} (#{cslack['", n, "'].to_f.signif()})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'cd8d7b\" ];\n"';
do forall <n> in N with B[n] > 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})\\nZ: #{slack['", n, "'].to_f.signif()} (#{cslack['", n, "'].to_f.signif()})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'fbc490\" ];\n"';
do forall <n> in N with B[n] <  0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})\\nZ: #{slack['", n, "'].to_f.signif()} (#{cslack['", n, "'].to_f.signif()})", '\"];\n"';
#
# Die nächste Zeile kann genutzt werden, wenn alle Kanten dargestellt werden sollen.
#do forall <i, j> in E do print '-RUBY-dotFile << "', i, '->', j, ' [ label = \"', "(#", '{cost["', i, '->', j, '"].to_f.signif()})', "\\nA: #{", dist[i,j], ".to_f.signif(1)}/#{", dmax, ".to_f.signif(1)} = #{", dist[i,j]/dmax, '.signif(1)}', "\\n#", '{flow["', i, '->', j, '"].to_f.signif()} in [', "#", '{', capl[i, j], '.signif()}', ", #", '{', capu[i, j], ".signif()}]", '\" ]\n"';
# Die nächste Zeile kann genutzt werden, wenn nur die Kanten mit Kosten durch Flüsse dargestellt werden sollen
do forall <i, j> in E do print '-RUBY-if cost["', i, '->', j, '"].to_f.signif() > 0 then dotFile << "', i, '->', j, ' [ label = \"', "(#", '{cost["', i, '->', j, '"].to_f.signif()})', "\\nA: #{", dist[i,j], ".to_f.signif(1)}/#{", dmax, ".to_f.signif(1)} = #{", dist[i,j]/dmax, '.signif(1)}', "\\n#", '{flow["', i, '->', j, '"].to_f.signif()} in [', "#", '{', capl[i, j], '.signif()}', ", #", '{', capu[i, j], ".signif()}]", '\" ]\n" end';
do print '-RUBY-dotFile << "\noverlap = false\n"';
do print '-RUBY-dotFile << "\nlabeljust=left"';
do print '-RUBY-dotFile << "\n}"';
do print '-RUBY-File.write(ARGV[0] + ".dot", dotFile)';
do print '-RUBY-system("dot -Tpng -Gdpi=150 #{ARGV[0]}.dot > #{ARGV[0]}.png")';
###########################################################

