# Set up simplecov
require 'simplecov'
SimpleCov.start { add_filter '/spec/' }

# Set up bundler
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

# Require tracking
require_relative '../lib/tracking'
@tracking_path = File.join(File.dirname(__FILE__), '..', 'bin', 'tracking')
@tracking_command = "ruby #{@tracking_path}"

# Helper methods

def capture_output &block
	original_stdout = $stdout
	$stdout = fake = StringIO.new
	begin
		yield
	ensure
		$stdout = original_stdout
	end
	fake.string
end

def test_command args=''
	capture_output do
		system "#{@tracking_command} #{args}"
	end
end

def backup_data
	FileUtils.cd File.expand_path('~/.tracking')
	FileUtils.mkdir 'test_backup'
	%w(config.yml data.csv).each do |f|
		FileUtils.mv(f, 'test_backup') if File.exist? f
	end
end

def restore_data
	FileUtils.cd File.expand_path('~/.tracking/test_backup')
	%w(config.yml data.csv).each do |f|
		FileUtils.mv(f, File.expand_path('..')) if File.exist? f
	end
	FileUtils.cd File.expand_path('..')
	FileUtils.rmdir 'test_backup'
end
