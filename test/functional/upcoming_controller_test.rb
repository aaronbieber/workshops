require File.dirname(__FILE__) + '/../test_helper'
require 'upcoming_controller'

# Re-raise errors caught by the controller.
class UpcomingController; def rescue_action(e) raise e end; end

class UpcomingControllerTest < Test::Unit::TestCase
  def setup
    @controller = UpcomingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
