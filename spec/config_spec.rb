require 'spec_helper'

describe Tracking::Config do

	before(:all) { backup_data }
	after(:all)  { restore_data }

	it 'reads a value from the config file' do
		Tracking::Config[:lines].should == Tracking::Config.defaults[:lines]
	end

	it 'writes a value to the config file' do
		Tracking::Config[:lines] = 9001
		Tracking::Config[:lines].should == 9001
		File.exist?(Tracking::Config::PATH).should be_true
	end

	it 'creates a config file' do
		File.exist?(Tracking::Config::PATH).should be_true
	end

end
