require 'spec_helper'

describe Tracking::TrackingConfig do

  before(:all) { backup_data }
  after(:all)  { restore_data }

  it 'reads a value from the config file' do
    Tracking::TrackingConfig[:lines].should == Tracking::TrackingConfig.defaults[:lines]
  end

  it 'writes a value to the config file' do
    Tracking::TrackingConfig[:lines] = 9001
    Tracking::TrackingConfig[:lines].should == 9001
  end

  it 'creates a config file' do
    Tracking::TrackingConfig.write
    File.exist?(Tracking::TrackingConfig::PATH).should be_true
  end

end
