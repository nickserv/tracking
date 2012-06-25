task :install do
	puts "Installing Tracking...."
	Rake::Task[:link].execute
	puts "Tracking has been successfully installed!"
	puts "Try running \"tracking\" now. If it doesn't work, make sure ~/bin (or ~/Bin) is in your PATH."
end

desc "reset tracking to its default settings and clear its data file"
task :reset do
	#TODO
end

=begin
desc "update Tracking to a stable release (force stable update)"
end
=end

desc "pull tracking's git repository (force unstable update)"
task :pull do
	puts "Pulling git repository...."
	system "git pull"
end

desc "link tracking to ~/bin"
task :link do
	puts "Linking Tracking to ~/bin...."
	if File.directory? File.expand_path("~/Bin")
		ln_s File.expand_path("command_line.rb"), File.expand_path("~/Bin/tracking")
	else
		mkdir File.expand_path("~/bin") unless File.directory? file.expand_path("~/bin")
		ln_s File.expand_path("command_line.rb"), File.expand_path("~/bin/tracking")
	end
end

task :default => [:pull]
