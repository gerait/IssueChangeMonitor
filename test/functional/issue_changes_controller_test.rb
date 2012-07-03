require File.expand_path('../../test_helper', __FILE__)

class IssueChangesControllerTest < ActionController::TestCase
  fixtures :issues, :users, :members
  
  def setup
    @controller = IssueChangesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = User.find(2)
    @request.session[:user_id] = User.current.id
    @issue = Issue.find(1)
  end
  
  def test_check
    IssueChange.stubs(:change_label_for).returns(["[New]", 'new_issue_change_label'])
    get :check, :format => :json, :issue_id => @issue.id
    assert_response :success
    assert_equal "application/json", @response.content_type
    assert_equal "[New]", assigns(:label)
    assert_equal "new_issue_change_label", assigns(:css_class)
  end
end
