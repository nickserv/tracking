# Set up simplecov
require 'simplecov'
SimpleCov.start { add_filter '/spec/' }

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tracking'

# Helper methods

def test_command args=''
  capture_output do
    Tracking::CLI.parse args.split(' ')
  end
end

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
