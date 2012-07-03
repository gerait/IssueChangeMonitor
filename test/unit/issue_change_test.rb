require File.expand_path('../../test_helper', __FILE__)

class IssueChangeTest < ActiveSupport::TestCase
  fixtures :issues, :users, :members, :issue_changes
  
  should belong_to(:issue)
  should belong_to(:member)
  
  should validate_presence_of(:issue)
  should validate_presence_of(:member)
  context "uniqueness" do
    should "check uniqueness" do
      duplicate = IssueChange.new(:member_id => IssueChange.find(1).member_id, :issue_id => IssueChange.find(1).issue_id)
      duplicate.valid?
      assert duplicate.errors[:issue_id].present?
    end
  end
  
  context "#class" do
    context "#change_label_for" do
      def setup
        @issue_change = IssueChange.find(1)
        @member = @issue_change.member
        @user = @member.user 
        @issue = @issue_change.issue
      end 
      should "return New if member doesn't view issue before" do
        IssueChange.delete_all
        assert_equal ["[New]", 'new_issue_change_label'], IssueChange.change_label_for(@user, @issue.id)
      end
      should "return Updated if issue changed from last view of member" do
        assert_equal ["[Updated]", 'update_issue_change_label'], IssueChange.change_label_for(@user, @issue.id)
      end
      should "return empty string if issue doesn't changed from last view of member" do
        @issue_change.update_attribute(:updated, false)
        assert_equal [], IssueChange.change_label_for(@user, @issue.id)
      end
    end
  end
  
end
