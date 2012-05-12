$filename = "data.txt"
list = []

module List

	def self.print
		File.open($filename,"r").each do |l|
			puts l
		end
	end

	def self.add item
		File.open($filename,"a") do |f|
			date = "DATE"
			f.write("\n"+date+" "+item)
		end
	end

	def self.clear
		File.open($filename,"w") do |f|
			f.write ""
		end
	end

	def self.edit
		system ENV["EDITOR"] + " " + $filename
	end

end

if ARGV.length == 0
	puts "DEBUG: printing"
	List.print
else
	if ARGV[0] == "clear"
		puts "DEBUG: clearing"
		List.clear
	elsif ARGV[0] == "edit"
		puts "DEBUG: editing"
		List.edit
	else
		puts "DEBUG: adding"
		List.add ARGV[0]
		List.print
	end
end
