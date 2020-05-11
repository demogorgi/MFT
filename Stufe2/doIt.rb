#!/usr/bin/ruby
# ####################################################
# Invocation:
# TODO_______Argument wihtout extensions: path_to_first_step_data
# TODO_______Example: ruby doIt.rb up_03_big/up_03
# ####################################################

# generates lp file for scip
def zimplit(data, model)
    #puts "zimpl -l 100 #{data}.zpl #{model}.zpl"
    puts `zimpl -l 100 #{data}.zpl #{model}.zpl`
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

# gets relevant params from step 2.1 for step 2.2
def getParams(solFile)
    params = ""
    File.open(solFile).each {|l|
	if l =~ /sum|Glo |GBH. /
	    params += "param " + l.sub(/\s+/," := ").sub(/\s+\(.*/,";")
	end
    }
    params
end

# generates control file for scip
def scipfile(data)
    puts(data)
    #puts content = "set write printzeros TRUE\nr #{data}.lp\no\ndis solu\nw solut \"#{data}.sol\"\nq\n"
    puts content = "set write printzeros TRUE\nr #{data}.lp\no\nw solut \"#{data}.sol\"\nq\n"
    File.open(data + ".scip", "w") { |f| f.write(content) }
    data + ".scip"
end

# directory with test case
wdir = File.dirname(ARGV[0])
# data for step 2.1 - 2.3
data21 = File.basename(ARGV[0])
data22 = File.basename(ARGV[1])
data23 = File.basename(ARGV[1]) + "_23"
# directory with mft11, mft12 and doIt.rb
modeldir = __dir__
# Go into testcase directory
Dir.chdir(wdir)
# model for step 2.1
model21 = File.join(modeldir, "mft21")
# model for step 2.2
model22 = File.join(modeldir, "mft22")
# model for step 2.3
model23 = File.join(modeldir, "mft23")
# 
# Step 2.1
# generate lp-file for step 2.1
zimplit(data21, model21)
# generate control file for step 2.1 for scip
s1 = scipfile(data21)
# execute scip with control file for step 2.1
puts `scip < #{s1}`
# display relevant part
puts "###### 2.1 global and quality ##################################"
system("grep -E \"Glo |GBH. \" #{data21}.sol")
puts "################################################################\n\n"
#
# Step 2.2
# generate lp-file for step 2.1
zimplit(data22, model22)
# generate control file for step 2.1 for scip
s2 = scipfile(data22)
# execute scip with control file for step 2.1
puts `scip < #{s2}`
puts "###### 2.2 get Glo, GBH1/2 U and Z for next step ###############"
puts params = getParams(data22 + ".sol")
puts "################################################################\n\n"
# prepend relevant part from step 2.2 to data for step 2.3
file_prepend(data22 + ".zpl", data23 + ".zpl", params)
#
# Step 2.3
# generate lp-file for step 2.3
zimplit(data23, model23)
# generate control file for step 1.2 for scip
s3 = scipfile(data23)
# execute scip with control file for step 2.3
puts `scip < #{s3}`
puts "###### 2.3 get u_n, z_n ########################################"
system("grep -E \"^[uz]\\\\$\" #{data23}.sol")
puts "################################################################\n\n"
