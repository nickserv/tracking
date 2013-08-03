require 'spec_helper'

describe Tracking do

  it 'should have a version number' do
    Tracking::VERSION.should_not be_nil
  end

end
