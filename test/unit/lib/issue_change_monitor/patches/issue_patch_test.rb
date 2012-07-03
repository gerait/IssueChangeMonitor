require File.expand_path('../../../../../test_helper', __FILE__)

class IssuePatchTest < ActiveSupport::TestCase
  fixtures :issues, 
           :issue_changes, 
           :projects,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :journals,
           :journal_details,
           :queries,
           :repositories,
           :changesets    
    
  context "after update" do
    context "#update_issue_change" do
      should "update all issue changes record" do
        @issue_change = IssueChange.find(1)
        @issue = @issue_change.issue
        assert @issue_change.update_attribute(:updated, false), "update failed"
        assert @issue.update_attributes(:subject => "new subject"), "update failed"
        assert @issue_change.reload.updated, "should be true"
      end 
    end
  end
end
