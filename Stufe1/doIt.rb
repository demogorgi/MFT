#!/usr/bin/ruby
require 'pp'
# ####################################################
# Invocation:
# Argument wihtout extensions: path_to_first_step_data
# Example: ruby doIt.rb up_03_big/up_03
# ####################################################

# generates lp file for scip
def zimplit(data, model)
    puts "zimpl -l 100 #{data}.zpl #{model}.zpl"
    zpl = `zimpl -l 100 #{data}.zpl #{model}.zpl`
    #puts zpl
    zpl
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

# gets relevant part of the solution from 1.2 for 1.3
def get_puzZ(model)
    puzZ = nil
    File.open model + ".sol" do |file|
	puzZ = file.find_all { |line| line =~ /^[puzZ]\$/ }
    end
    a = puzZ.map { |x| x.match(/(^[^\s]+)\s+([0-9.+-e]+)/)[1,2] }.sort
    b = a.group_by{|x| x[0][0]}
    str = ""
    b.each{|k,v|
         str += "param fix_#{k}[N] :=\n"
	 v.each{|x| str += "<\"#{x[0].sub(/.*\$/,"")}\"> #{x[1]},\n"}
    }
    r = "\n\n# Aus Schritt 1.2\n" + str.gsub(",\nparam",";\nparam").reverse.sub(",", ";").reverse
    #puts r
    r
end

# gets relevant part of the solution from 1.2 for 1.3
def get_crpuzZ(model)
    crpuzZ = nil
    File.open model + ".sol" do |file|
	crpuzZ = file.find_all { |line| line =~ /^cr[puzZ]\$/ }
    end
    a = crpuzZ.map { |x| x.match(/(^[^\s]+)\s+([0-9.+-e]+)/)[1,2] }.sort
    b = a.group_by{|x| x[0][2]}
    str = ""
    b.each{|k,v|
         str += "param fix_cr#{k}[N] :=\n"
	 v.each{|x| str += "<\"#{x[0].sub(/.*\$/,"")}\"> #{x[1]},\n"}
    }
    r = "\n\n# Aus Schritt 1.2\n" + str.gsub(",\nparam",";\nparam").reverse.sub(",", ";").reverse
    #puts r
    r
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
# directory with mft11, mft12 and doIt.rb
modeldir = __dir__
# Go into testcase directory
Dir.chdir(wdir)

# model for step 1.1
model1 = File.join(modeldir, "mft11")
# model for step 1.2
model2 = File.join(modeldir, "mft12")
# model for step 1.3
model3 = File.join(modeldir, "mft13")
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
zimplit(data2, model2)
# generate control file for step 1.2 for scip
s2 = scipfile(data2)
# execute scip with control file for step 1.2
puts `scip < #{s2}`
# prepend relevant part from step 1.2 to data for step 1.3
file_postpend(data1 + ".zpl", data3 + ".zpl", get_puzZ(data2))
file_postpend(data3 + ".zpl", data3 + ".zpl", get_crpuzZ(data2))

# generate lp-file for step 1.3
graphviz_ruby = zimplit(data3, model3)
# generate control file for step 1.3 for scip
s3 = scipfile(data3)
# execute scip with control file for step 1.3
puts `scip < #{s3}`

# write ruby code to file
File.open(data3 + ".rb", "w") { |f| f.write(get_ruby_code(graphviz_ruby)) }
# execute ruby code to generate png file with graphviz (visualization of the problem and its solution)
system("ruby #{data3}.rb #{data3}.sol")
