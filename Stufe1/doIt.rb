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

def get_ruby_code(str)
    str.scan(/RUBY.*$/).map{ |l| l.sub("RUBY-","") }.join("\n")
end

def quadratify(model)
    quadratic_model = ""
    File.open(model + ".lp").each do |line|
	if line.include?("QQ")
	    if line =~ /<=.*<=/
		next
	    else
		#quadratic_model += line.sub("QQ","").sub(/([\+\-\. e0-9]* [fuk][^ ]+ )/,'[ \1^2 ] / 2 ')
		quadratic_model += line.sub("QQ","").sub(/([\+\-\. e0-9]* [fuk][^ ]+ )/,' [ \1^2 ] ')
	    end
	else
	    quadratic_model += line
	end
    end
    File.write(model + "_quad.lp", quadratic_model)
end

# directory with test case
wdir = File.dirname(ARGV[0])
# data for step 1.1
data1 = File.basename(ARGV[0])
# directory with mft11, mft12 and doIt.rb
modeldir = __dir__
# Go into testcase directory
Dir.chdir(wdir)

# model for step 1.1
model1 = File.join(modeldir, "mft11")
# model for step 1.2
model2 = File.join(modeldir, "mft12")
# data for step 1.2
data2 = data1 + "_12"

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
# introduce quadratic constraints in lp-file for step 1.2
quadratify(data2)
# generate control file for step 1.2 for scip
s2 = scipfile(data2 + "_quad")
# execute scip with control file for step 1.2
puts `scip < #{s2}`

# write ruby code to file
File.open(data2 + ".rb", "w") { |f| f.write(get_ruby_code(graphviz_ruby)) }
# execute ruby code to generate png file with graphviz (visualization of the problem and its solution)
system("ruby #{data2}.rb #{data2}_quad.sol")
