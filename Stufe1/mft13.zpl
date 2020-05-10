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
var crp[N] real >= 0;
# Unterbrechungsmodell
var u[N] real >= -infinity;
var cru[N] real >= 0;
# Kürzungsmodell
var z[N] real >= -infinity;
var crz[N] real >= 0;
# Slackmodell
var Z[N] >= -infinity;
var crZ[N] real >= 0;

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
subto fixcrp:
      forall <n> in N: crp[n] == fix_crp[n];
subto fixcru:
      forall <n> in N: cru[n] == fix_cru[n];
subto fixcrz:
      forall <n> in N: crz[n] == fix_crz[n];
subto fixcrZ:
      forall <n> in N: crZ[n] == fix_crZ[n];

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
do print '-RUBY-class Float';
do print '-RUBY-  def signif(signs)';
do print '-RUBY-    Float("%.#{signs}g" % self)';
do print '-RUBY-  end';
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
#do print '-RUBY-    puts(SlackSolution)';
do print '-RUBY-    SlackSolution.each{|x| slack[x.match(/^Z\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
do print '-RUBY-end';
do print '-RUBY-print("Slack: ")';
do print '-RUBY-puts(slack)';
#
do print '-RUBY-SlackCostSolution = File.open(ARGV[0]).grep(/^crZ\$/)';
do print '-RUBY-if SlackCostSolution != []';
#do print '-RUBY-    puts(SlackCostSolution)';
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
do forall <n> in N with B[n] == 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [#{", pl[n], ".to_f.signif(4)}, #{", pu[n], ".to_f.signif(4)}]: #{buffer['", n, "'].to_f.signif(4)} (#{cbuffer['", n, "'].to_f.signif(4)})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif(4)} (#{cinterrupt['", n, "'].to_f.signif(4)})\\nz in [#{", zl[n], ".to_f.signif(4)}, #{", zu[n], ".to_f.signif(4)}]: #{curtail['", n, "'].to_f.signif(4)} (#{ccurtail['", n, "'].to_f.signif(4)})\\nZ: #{slack['", n, "'].to_f.signif(4)} (#{cslack['", n, "'].to_f.signif(4)})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'cd8d7b\" ];\n"';
do forall <n> in N with B[n] > 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [#{", pl[n], ".to_f.signif(4)}, #{", pu[n], ".to_f.signif(4)}]: #{buffer['", n, "'].to_f.signif(4)} (#{cbuffer['", n, "'].to_f.signif(4)})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif(4)} (#{cinterrupt['", n, "'].to_f.signif(4)})\\nz in [#{", zl[n], ".to_f.signif(4)}, #{", zu[n], ".to_f.signif(4)}]: #{curtail['", n, "'].to_f.signif(4)} (#{ccurtail['", n, "'].to_f.signif(4)})\\nZ: #{slack['", n, "'].to_f.signif(4)} (#{cslack['", n, "'].to_f.signif(4)})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'fbc490\" ];\n"';
do forall <n> in N with B[n] <  0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [#{", pl[n], ".to_f.signif(4)}, #{", pu[n], ".to_f.signif(4)}]: #{buffer['", n, "'].to_f.signif(4)} (#{cbuffer['", n, "'].to_f.signif(4)})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif(4)} (#{cinterrupt['", n, "'].to_f.signif(4)})\\nz in [#{", zl[n], ".to_f.signif(4)}, #{", zu[n], ".to_f.signif(4)}]: #{curtail['", n, "'].to_f.signif(4)} (#{ccurtail['", n, "'].to_f.signif(4)})\\nZ: #{slack['", n, "'].to_f.signif(4)} (#{cslack['", n, "'].to_f.signif(4)})", '\"];\n"';
#
# Die nächste Zeile kann genutzt werden, wenn alle Kanten dargestellt werden sollen.
#do forall <i, j> in E do print '-RUBY-dotFile << "', i, '->', j, ' [ label = \"', "(#", '{cost["', i, '->', j, '"].to_f.signif(4)})', "\\nA: #{", dist[i,j], ".to_f.signif(1)}/#{", dmax, ".to_f.signif(1)} = #{", dist[i,j]/dmax, '.to_f.signif(1)}', "\\n#", '{flow["', i, '->', j, '"].to_f.signif(4)} in [', "#", '{', capl[i, j], '.to_f.signif(4)}', ", #", '{', capu[i, j], ".to_f.signif(4)}]", '\" ]\n"';
# Die nächste Zeile kann genutzt werden, wenn nur die Kanten mit Kosten durch Flüsse dargestellt werden sollen
do forall <i, j> in E do print '-RUBY-if cost["', i, '->', j, '"].to_f.signif(4) > 0 then dotFile << "', i, '->', j, ' [ label = \"', "(#", '{cost["', i, '->', j, '"].to_f.signif(4)})', "\\nA: #{", dist[i,j], ".to_f.signif(1)}/#{", dmax, ".to_f.signif(1)} = #{", dist[i,j]/dmax, '.to_f.signif(1)}', "\\n#", '{flow["', i, '->', j, '"].to_f.signif(4)} in [', "#", '{', capl[i, j], '.to_f.signif(4)}', ", #", '{', capu[i, j], ".to_f.signif(4)}]", '\" ]\n" end';
do print '-RUBY-dotFile << "\noverlap = false\n"';
do print '-RUBY-dotFile << "\nlabeljust=left"';
do print '-RUBY-dotFile << "\n}"';
do print '-RUBY-File.write(ARGV[0] + ".dot", dotFile)';
do print '-RUBY-system("dot -Tpng -Gdpi=150 #{ARGV[0]}.dot > #{ARGV[0]}.png")';
###########################################################

