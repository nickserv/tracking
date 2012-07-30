$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

class TestCLI < Test::Unit::TestCase
	context "Tracking's CLI" do


		should "clear list (to prepare for other tests)" do
			test_command "-c"
		end

		should "display empty list" do
			test_command
		end

		should "add a task" do
			test_command "first task"
		end

		should "add another task" do
			test_command "second task"
		end

		should "display list with two items" do
			test_command
		end

		should "delete the second task" do
			test_command "-d"
		end

		should "clear list" do
			test_command "-c"
		end

		should "display help information (run from the system's shell)" do
			test_command "-h"
		end

	end
end
