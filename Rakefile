task :install do
	puts "Installing Tracking...."
	Rake::Task[:link].execute
end

task :reset do
	#TODO
end

=begin
desc "Update Tracking to a stable release (force stable update)"
end
=end

desc "Pull Tracking's git repository (force unstable update)"
task :pull do
	puts "Pulling git repository..."
	system "git pull"
end

desc "Link Tracking to ~/bin"
task :link do
	if File.directory? "~/bin"
		ln_s "command_line.rb", "~/bin"
	elsif File.directory? "~/Bin"
		ln_s "command_line.rb", "~/Bin"
	else
		mkdir "~/bin"
		ln_s "command_line.rb", "~/bin"
	end
end

task :default => [:pull]
