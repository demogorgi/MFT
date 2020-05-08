# Wenn eine Kürzungsgrenze (fast) 0 ist (=Datenfehler) wird die Grenze auf 1% der durchschnittlich auftretenden Grenze gesetzt
# Dies ist erforderlich, um ohne die Einführung weiterer Variablen stets ein zulässiges Modell zu haben und numerische Probleme zu vermeiden.
param eps := 0.001; # Das heißt fast 0
param L := card({ <n> in N with zl[n] < - eps }); # Anzahl der Knoten mit ordentlicher unterer Kürzungsgrenze
param U := card({ <n> in N with zu[n] > eps }); # Anzahl der Knoten mit ordentlicher oberer Kürzungsgrenze
param mean_zbound := ( abs( sum <n> in N with zl[n] < - eps: zl[n] / L ) + abs( sum <n> in N with zu[n] > eps: zu[n] / U ) ) / 2;
defnumb zbound_correction(bound) := if abs(bound) < eps then
                                       if mean_zbound == 0 then
                                          1
                                       else
                                          0.01 * abs(mean_zbound)
                                       end
                                    else 
                                       abs(bound)
                                    end;

# Maximal auftretende Kantenlänge
param dmax := max <i, j> in E : dist[i, j];

# Skalierung der Kürzungspotenziale
# Die Kürzungsschranken werden so skaliert, dass in jedem Knoten
# die komplette Betragssumme der Schiefstände gekürzt werden kann, um immer zulässig zu sein.
param sum_abs_B := sum <n> in N: abs(B[n]); # Betragssumme der Schiefstände
param min_abs_bound := min <n> in N: min ( abs(zbound_correction(zl[n])), abs(zbound_correction(zu[n])) ); # Betragsmäßig kleinste Kürzungsschranke
do print "-------------";
do print "zbound_correction:";
do forall <n> in N do print zbound_correction(zl[n]);
do print "mean_zbound = ", mean_zbound;
do print "sum_abs_B = ", sum_abs_B;
do print "min_abs_bound = ", min_abs_bound;
param scaling := if min_abs_bound < sum_abs_B then sum_abs_B / min_abs_bound else 1 end; # Skalierungsfaktor. ACHTUNG, der sollte nicht zu groß werden, um numerische Probleme zu verhindern.
do forall <n> in N do print - scaling * zbound_correction(zl[n]), " <= z[", n, "] <= ", scaling * zbound_correction(zu[n]);
do print "-------------";

# Maximal auftretende Puffergrenze (Betrag)
param plmax := max <n> in N : abs(pl[n]);
param pumax := max <n> in N : abs(pu[n]);
param pmax := max(plmax,pumax);

# Maximal auftretende Unterbrechungsgrenze (Betrag)
param ulmax := max <n> in N : abs(ul[n]);
param uumax := max <n> in N : abs(uu[n]);
param umax := max(ulmax,uumax);

# Maximal auftretende Kürzungsgrenze (Betrag)
param zlmax := max <n> in N : zbound_correction(zl[n]);
param zumax := max <n> in N : zbound_correction(zu[n]);
param zmax := max(zlmax,zumax);

## Maximal auftretende Slacks
#param ZZmax := sum <n> in N: abs(B[n]);
##
#param aDZZl[<i> in N] := uzb(ZZmax,cmd,ZZmax);
#param aDZZu[<i> in N] := uzb(ZZmax,cmd,ZZmax);

# Puffer-/Unterbrechungs-/Kürzungskosten
param cmd := max(pmax,umax,scaling * zmax);
#param cmd := 10000000;
# Das ist der Koeffizient einer Parabel mit der Eigenschaft, ...
defnumb uzb(unt_kuz_max,cmD,bound) := if abs(bound) < eps then 0 else cmD / ( unt_kuz_max * abs(bound) ) end;

#
param aDpl[<i> in N] := uzb(pmax,cmd,pl[i]);
param aDpu[<i> in N] := uzb(pmax,cmd,pu[i]);
#
param aDul[<i> in N] := uzb(umax,cmd,ul[i]);
param aDuu[<i> in N] := uzb(umax,cmd,uu[i]);
#
param aDzl[<i> in N] := uzb(zbound_correction(zmax),cmd,zbound_correction(zl[i]));
param aDzu[<i> in N] := uzb(zbound_correction(zmax),cmd,zbound_correction(zu[i]));
do print ">>>>>>>>>>>>>>>>>>";
do forall <i> in N do print "aDzl = ", aDzl[i], " ,  aDzu = ", aDzu[i];

# Normale Kantenflüsse: Koeffizienten für Parabel zwischen capl und capu mit Scheitelpunkt (capl, 0) und Maximum cmF bei capu.
param cmF := 1;
param aF[<i, j> in E] := if capu[i,j] == capl[i,j] then 0 else dist[i,j] / dmax * cmF / ( capu[i, j] - capl[i, j] ) ** 2 end;

### Variablen
# Kantenflussvariablen
var f[E] real >= 0;
var cf[E] real >= 0;
# Puffernutzung
var p[N] real >= -infinity;
var p_pos[N] real >= 0;
var p_neg[N] real >= 0;
var p_abs[N] real >= 0;
var crpl[N] real >= 0;
var crpu[N] real >= 0;
var crp[N] real >= 0;
# Unterbrechungsmodell
var u[N] real >= -infinity;
var unt_pos[N] real >= 0;
var unt_neg[N] real >= 0;
var unt_abs[N] real >= 0;
var crul[N] real >= 0;
var cruu[N] real >= 0;
var cru[N] real >= 0;
# Kürzungsmodell
var z[N] real >= -infinity;
var kuz_pos[N] real >= 0;
var kuz_neg[N] real >= 0;
var kuz_abs[N] real >= 0;
var crzl[N] real >= 0;
var crzu[N] real >= 0;
var crz[N] real >= 0;
## Slackmodell
#var ZZ[N] >= -infinity;
#var ZZ_neg[N] real >= 0;
#var ZZ_pos[N] real >= 0;
#var ZZ_abs[N] real >= 0;
#var crZZl[N] real >= 0;
#var crZZu[N] real >= 0;
#var crZZ[N] real >= 0;

### Zielfunktion
# Minimiere Kosten
#minimize obj: sum <i,j> in E: cf[i,j] + sum <n> in N: ( crp[n] + cru[n] + crz[n] + crZZ[n] );
minimize obj: sum <i,j> in E: cf[i,j] + sum <n> in N: ( crp[n] + cru[n] + crz[n] );

### Nebenbedingungen
# Quadratische Kosten für Fluss
subto quadraticCostsFlow:
      forall <i, j> in E: cf[i, j] >= aF[i,j] * ( f[i, j]^2 - 2 * f[i,j] * capl[i,j] );
# Quadratische Kosten Ratioabweichung Puffer
subto quadraticCostsBRatioLb:
      forall <i> in N: crpl[i] >= aDpl[i] * p_neg[i]^2;
subto quadraticCostsBRatioUb:
      forall <i> in N: crpu[i] >= aDpu[i] * p_pos[i]^2;
subto CostsRatioBbLb:
      forall <i> in N: crp[i] == crpl[i] + crpu[i];
# Quadratische Kosten Ratioabweichung Unterbrechung
subto quadraticCostsURatioLb:
      forall <i> in N: crul[i] >= aDul[i] * unt_neg[i]^2;
subto quadraticCostsURatioUb:
      forall <i> in N: cruu[i] >= aDuu[i] * unt_pos[i]^2;
subto CostsRatioUbLb:
      forall <i> in N: cru[i] == crul[i] + cruu[i];
# Quadratische Kosten Ratioabweichung Kuerzung
subto quadraticCostsZRatioLb:
      forall <i> in N: crzl[i] >= aDzl[i] * kuz_neg[i]^2;
subto quadraticCostsZRatioUb:
      forall <i> in N: crzu[i] >= aDzu[i] * kuz_pos[i]^2;
subto CostsRatioZbLb:
      forall <i> in N: crz[i] == crzl[i] + crzu[i];
## Quadratische Kosten Ratioabweichung Slack
#subto quadraticCostsZZRatioLb:
#      forall <i> in N: crZZl[i] >= aDZZl[i] * ZZ_neg[i]^2;
#subto quadraticCostsZZRatioUb:
#      forall <i> in N: crZZu[i] >= aDZZu[i] * ZZ_pos[i]^2;
#subto CostsRatioZZbLb:
#      forall <i> in N: crZZ[i] == crZZl[i] + crZZu[i];

# Puffern
# p < 0 -> Befüllung des Puffers
# u > 0 -> Entnahme aus dem Puffer
# Betrag des Pufferns
subto pabs1:
      forall <n> in N: p[n] == p_pos[n] - p_neg[n];
subto pabs2:
      forall <n> in N: p_abs[n] == p_pos[n] + p_neg[n];
# Puffergrenzen
subto puffergrenzen:
      forall <n> in N: pl[n] <= p[n] <= pu[n];
# Unterbrechungsbetragssumme
subto pufferbetragssumme:
      sum_abs_p == sum <n> in N: p_abs[n];

# Unterbrechungen
# u < 0 -> Entryunterbrechung
# u > 0 -> Exitunterbrechung
# Betrag der Unterbrechung
subto uabs1:
      forall <n> in N: u[n] == unt_pos[n] - unt_neg[n];
subto uabs2:
      forall <n> in N: unt_abs[n] == unt_pos[n] + unt_neg[n];
# Unterbrechungsgrenzen
subto unterbrechungsgrenzen:
      forall <n> in N: ul[n] <= u[n] <= uu[n];
# Unterbrechungsbetragssumme
subto unterbrechungsbetragssumme:
      sum_abs_unt == sum <n> in N: unt_abs[n];

# Kürzungen
# k < 0 -> Entrykürzung
# k > 0 -> Exitkürzung
# Betrag der Kürzungen
subto kabs1:
      forall <n> in N: z[n] == kuz_pos[n] - kuz_neg[n];
subto kabs2:
      forall <n> in N: kuz_abs[n] == kuz_pos[n] + kuz_neg[n];
# Kürzungsgrenzen
subto kuerzungsgrenzen:
      forall <n> in N: - scaling * zbound_correction(zl[n]) <= z[n] <= scaling * zbound_correction(zu[n]);
subto kuerzungsbetragssumme:
      sum_abs_kuz == sum <n> in N: kuz_abs[n];

## Slackvariable, um das Modell in jedem Fall zulässig zu machen
#subto slack1:
#      forall <n> in N: ZZ[n] == ZZ_pos[n] - ZZ_neg[n];
#subto slack2:
#      forall <n> in N: ZZ_abs[n] == ZZ_pos[n] + ZZ_neg[n];
#subto slackbetragssumme:
#      sum_abs_ZZ == sum <n> in N: ZZ_abs[n];

# Am Ende müssen alle Knoten ausgeglichen sein
subto flussbilanz:
      # Zufluss - Abfluss + Puffer + Unterbrechung + Kürzung = - Bilanz (Bilanz>0 Überdeckung, <0 Unterdeckung)
      #forall <n> in N: sum <i, n> in E: f[i, n] - sum <n, i> in E: f[n, i] + p[n] + u[n] + z[n] + ZZ[n] == - B[n];
      forall <n> in N: sum <i, n> in E: f[i, n] - sum <n, i> in E: f[n, i] + p[n] + u[n] + z[n] == - B[n];

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
#do print '-RUBY-SlackSolution = File.open(ARGV[0]).grep(/^ZZ\$/)';
#do print '-RUBY-if SlackSolution != []';
#do print '-RUBY-    puts(SlackSolution)';
#do print '-RUBY-    SlackSolution.each{|x| slack[x.match(/^ZZ\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
#do print '-RUBY-end';
#do print '-RUBY-print("Slack: ")';
#do print '-RUBY-puts(slack)';
##
#do print '-RUBY-SlackCostSolution = File.open(ARGV[0]).grep(/^crZZ\$/)';
#do print '-RUBY-if SlackCostSolution != []';
#do print '-RUBY-    puts(SlackCostSolution)';
#do print '-RUBY-    SlackCostSolution.each{|x| cslack[x.match(/^crZZ\$([^\s]+)/)[1].sub("$", "->")] = x.match(/\s(\S+)\s/)[1]}';
#do print '-RUBY-end';
#do print '-RUBY-print("Slackkosten: ")';
#do print '-RUBY-puts(cslack)';
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
do forall <n> in N with B[n] == 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})", '\"];\n"';#\\nZ: #{slack['", n, "'].to_f.signif()} (#{cslack['", n, "'].to_f.signif()})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'cd8d7b\" ];\n"';
do forall <n> in N with B[n] > 0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})", '\"];\n"';#\\nZ: #{slack['", n, "'].to_f.signif()} (#{cslack['", n, "'].to_f.signif()})", '\"];\n"';
#
do print '-RUBY-dotFile << "\nnode [ fillcolor = ', '\"', "#", 'fbc490\" ];\n"';
do forall <n> in N with B[n] <  0 do print '-RUBY-dotFile << "', n, ' [ label = \"', n, ': ', B[n], "\\np in [", pl[n], ", ", pu[n], "]: #{buffer['", n, "'].to_f.signif()} (#{cbuffer['", n, "'].to_f.signif()})\\nu in [", ul[n], ", ", uu[n], "]: #{interrupt['", n, "'].to_f.signif()} (#{cinterrupt['", n, "'].to_f.signif()})\\nz in [", zl[n], ", ", zu[n], "]: #{curtail['", n, "'].to_f.signif()} (#{ccurtail['", n, "'].to_f.signif()})", '\"];\n"';#\\nZ: #{slack['", n, "'].to_f.signif()} (#{cslack['", n, "'].to_f.signif()})", '\"];\n"';
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

