require 'fileutils'
tdirs = Dir.glob('*').select {|f| File.directory? f}.sort()
Dir.mkdir("Tests") unless File.exists?("Tests")
tdirs.each{ |test|
    if !Dir[test + "/*.zpl"].empty?
        system("ruby doIt.rb #{test}/#{test}")
        puts f = "#{test}/#{test}_12_13.sol.png"
        FileUtils.mv(f,"Tests/")
    end
}
