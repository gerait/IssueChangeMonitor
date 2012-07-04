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
    
  context "#delete_issue_changes" do
    should "delete member issue changes records" do
      @issue_change = IssueChange.find(1)
      @member = @issue_change.member
      assert @member.destroy
      assert IssueChange.find_by_id(1).nil?
    end 
  end
end
