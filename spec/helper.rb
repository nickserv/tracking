require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require_relative '../lib/tracking'

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
