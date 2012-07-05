require File.expand_path('../../../../../test_helper', __FILE__)

class MemberPatchTest < ActiveSupport::TestCase
  fixtures :issues, 
           :projects,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :issue_categories,
           :journals,
           :journal_details
  
  should "has many issue changes" do
    issue_change = IssueChange.find(1)
    member = issue_change.member
    assert member.respond_to?(:issue_changes)
    assert_equal [issue_change], member.issue_changes
  end 
end
