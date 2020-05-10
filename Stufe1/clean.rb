require 'fileutils'
tdirs = Dir.glob('*').select {|f| File.directory? f}.sort()
tdirs.each{ |test|
    Dir[test + "/" + '*{png,lp,tbl,sol,scip,dot,rb}'].each{|f|
	puts "lösche #{f}"
	File.delete(f)
    }
}
