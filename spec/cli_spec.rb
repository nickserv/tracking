require 'spec_helper'

describe Tracking::CLI do

	before(:all) { backup_data }
	after(:all)  { restore_data }

	it 'performs a few operations on a new list and then clears it' do
		test_command '-c'
		test_command
		test_command 'first task'
		test_command 'second task'
		test_command '-r second task, renamed'
		test_command
		test_command '-a'
		test_command '-n 1'
		test_command
		test_command '-d'
		test_command '-c'
	end

	it 'displays help information' do
		test_command '-h'
	end

	it 'pads and aligns text' do
		Tracking::CLI.pad('test', 8, :left).should == 'test    '
		Tracking::CLI.pad('test', 8, :right).should == '    test'
		Tracking::CLI.pad('test', 8, :center).should == '  test  '
	end

end
