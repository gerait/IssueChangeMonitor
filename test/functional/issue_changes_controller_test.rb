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
  
  def test_check_all
    project = Project.find 1
    member = Member.find 1
    labels = {1 => ["[New]", 'new_issue_change_label']}
    Member.any_instance.stubs(:find_by_project_id_and_user_id).returns(member)
    IssueChange.stubs(:all_change_label_for).returns(labels)
    post :check_all, :format => :js, :issue_ids => [@issue.id], :project_id => project.id
    assert_response :success
    assert_template 'check_all'
    assert_equal "text/javascript", @response.content_type
    assert_equal labels, assigns(:issue_changes_labels)
  end
end
