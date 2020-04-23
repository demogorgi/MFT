#!/usr/bin/ruby
require 'pp'
# ####################################################
# Invocation:
# Argument wihtout extensions: path_to_first_step_data
# Example: ruby doIt.rb up_03_big/up_03
# ####################################################

# generates lp file for scip
def zimplit(data, model)
    #puts "zimpl -l 100 #{data}.zpl #{model}.zpl"
    `zimpl -l 100 #{data}.zpl #{model}.zpl`
end

# generates control file for scip
def scipfile(data)
    puts(data)
    puts content = "set write printzeros TRUE\nr #{data}.lp\no\nw solut \"#{data}.sol\"\nq\n"
    File.open(data + ".scip", "w") { |f| f.write(content) }
    data + ".scip"
end

# gets relevant part of the solution from 1.1 for 1.2
def get_sum_abs(model)
    sum_abs = nil
    File.open model + ".sol" do |file|
      sum_abs = file.find_all { |line| line =~ /sum_abs/ }
    end
    a = sum_abs.map { |x| x.match(/(^[^\s]+)\s+([0-9.+-e]+)/)[1,2] }
    b = a.map{ |y| "param " + y[0] + " := " + y[1] + ";" } 
    "# Aus Schritt 1.1\n" + b.join("\n") + "\n\n"
end

#def tight_bounds(model,lb_or_ub)
def tight_bounds(model)
    tight_bounds = []
    #is_bound_tight = File.open(model + ".sol").grep(/#{lb_or_ub}_info\$/)
    is_bound_tight = File.open(model + ".sol").grep(/_info\$/)
    if is_bound_tight != []
	is_bound_tight.each{|x| 
	    value = x.match(/\s(\S+)\s/)[1]
            edge = x.match(/_info\$([^\s]+)/)[1].split("$")
	    if value.to_f.abs < 0.001
		tight_bounds << edge
	    end
	}
    end
    tight_bounds.uniq
end

# liefert die Liste der Knoten mit Unterbrechung oder Kürzung betragsmäßig größer 0.001
def zuz(model,u_oder_z)
    unt_kuz = []
    unts_kuzs = File.open(model + ".sol").grep(/^#{u_oder_z}\$/)
    if unts_kuzs != []
	unts_kuzs.each{|x| 
	    value = x.match(/\s(\S+)\s/)[1]
            node = x.match(/^#{u_oder_z}\$([^\s]+)/)[1]
	    if value.to_f.abs > 0.001
	        unt_kuz << node
	    end
	}
    end
    [unt_kuz, unts_kuzs]
end

# prepends str to file and writes this new_file
def file_prepend(file, new_file, str)
  new_contents = ""
  File.open(file, 'r') do |fd|
    contents = fd.read
    new_contents = str << contents
  end
  File.open(new_file, 'w') do |fd| 
    fd.write(new_contents)
  end
end

# postpends str to file and writes this new_file
def file_postpend(file, new_file, str)
  new_contents = ""
  File.open(file, 'r') do |fd|
    contents = fd.read
    new_contents = contents << str
  end
  File.open(new_file, 'w') do |fd| 
    fd.write(new_contents)
  end
end

def get_ruby_code(str)
    str.scan(/RUBY.*$/).map{ |l| l.sub("RUBY-","") }.join("\n")
end

# directory with test case
wdir = File.dirname(ARGV[0])
# data for step 1.1
data1 = File.basename(ARGV[0])
# directory with mft11, mft12, mft13 and doIt.rb
modeldir = __dir__
# Go into testcase directory
Dir.chdir(wdir)

# model for step 1.1
model1 = File.join(modeldir, "mft11")
# model for step 1.2
model2 = File.join(modeldir, "mft12")
# model for step 1.3
model3 = File.join(modeldir, "mft13")
model3tmp = File.join(modeldir, "mft13tmp")
# data for step 1.2
data2 = data1 + "_12"
# data for step 1.3
data3 = data2 + "_13"

# generate lp-file for step 1.1
zimplit(data1, model1)
# generate control file for step 1.1 for scip
s1 = scipfile(data1)
# execute scip with control file for step 1.1
puts `scip < #{s1}`
# prepend relevant part from step 1.1 to data for step 1.2
file_prepend(data1 + ".zpl", data2 + ".zpl", get_sum_abs(data1))

# generate lp-file for step 1.2
graphviz_ruby = zimplit(data2, model2)
# generate control file for step 1.2 for scip
s2 = scipfile(data2)
# execute scip with control file for step 1.2
puts `scip < #{s2}`

# write ruby code to file
File.open(data2 + ".rb", "w") { |f| f.write(get_ruby_code(graphviz_ruby)) }
# execute ruby code to generate png file with graphviz (visualization of the problem and its solution)
system("ruby #{data2}.rb #{data2}.sol")
