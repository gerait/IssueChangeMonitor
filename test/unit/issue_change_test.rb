require File.expand_path('../../test_helper', __FILE__)

class IssueChangeTest < ActiveSupport::TestCase
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
           :journals
  
  context "uniqueness" do
    should "check uniqueness" do
      duplicate = IssueChange.new(:member_id => IssueChange.find(1).member_id, :issue_id => IssueChange.find(1).issue_id)
      duplicate.valid?
      assert duplicate.errors[:issue_id].present?
    end
  end
  
  def setup
    @issue_change = IssueChange.find(1)
  end
  
  context "#change_label_for" do
    should "return New if member doesn't view issue before" do
      user = @issue_change.member.user 
      IssueChange.delete_all
      assert_equal ["New", 'new_issue_change_label'], IssueChange.change_label_for(user, @issue_change.issue_id)
    end
    should "return Updated if issue changed from last view of member" do
      user = @issue_change.member.user 
      assert_equal ["Updated", 'update_issue_change_label'], IssueChange.change_label_for(user, @issue_change.issue_id)
    end
    should "return empty string if issue doesn't changed from last view of member" do
      user = @issue_change.member.user 
      @issue_change.update_attribute(:updated, false)
      assert_equal [], IssueChange.change_label_for(user, @issue_change.issue_id)
    end
    should "return empty string if issue updated before user became member of project" do
      member = @issue_change.member
      issue = @issue_change.issue
      user = @issue_change.member.user
      issue.update_attribute(:updated_on, Time.now - 1.days)
      member.update_attribute(:created_on, Time.now)
      IssueChange.delete_all
      assert_equal [], IssueChange.change_label_for(user, issue.id)
    end
  end
        
  context "#mark_as_viewed_or_create" do
    should "mark as viewed existed record" do
      @issue_change.update_attribute(:updated, true)
      IssueChange.mark_as_viewed_or_create(@issue_change.member.user, @issue_change.issue)
      assert_equal 1, IssueChange.count
      assert !@issue_change.reload.updated
    end
    should "create new record for issue and member" do
      IssueChange.delete_all
      member = Member.find(1)
      user = member.user
      issue = member.project.issues.first
      assert_equal 0, IssueChange.count
      IssueChange.mark_as_viewed_or_create(user, issue)
      assert_equal 1, IssueChange.count
      assert !IssueChange.last.updated
    end
  end
  
  context "#all_change_label_for" do
    should "prepare issue change label and return labels for issues which older then member created" do
      Issue.destroy_all
      IssueChange.destroy_all
      member = Member.find 1
      member.update_attribute(:created_on, Time.now - 1.hours)
      project = member.project
      
      new_issue = Issue.generate_for_project!(project)
      updated_issue = Issue.generate_for_project!(project)
      not_updated_issue = Issue.generate_for_project!(project)
      old_issue = Issue.generate_for_project!(project)
      old_create_updated_issue = Issue.generate_for_project!(project)
      old_issue.update_attribute(:updated_on, Time.now - 2.hours)
      old_create_updated_issue.update_attribute(:created_on, Time.now - 2.hours)
      old_create_updated_issue.update_attribute(:updated_on, Time.now)
      IssueChange.create!(:issue => updated_issue, :member => member, :updated => true)
      IssueChange.create!(:issue => not_updated_issue, :member => member, :updated => false)
      
      result = IssueChange.all_change_label_for(member, project.issues.map(&:id))
      assert_equal 3, result.size
      assert_equal ["New", 'new_issue_change_label'], result[new_issue.id]
      assert_equal ["Updated", 'update_issue_change_label'], result[updated_issue.id]
      assert_equal ["Updated", 'update_issue_change_label'], result[old_create_updated_issue.id]
    end
  end
  
  context "#turn_off_tracking_for_user" do
    should "remove issue changes if user turn off labels in preferences" do
      user = @issue_change.member.user
      user.pref[:show_issue_change_labels] = true
      user.save!
      IssueChange.turn_off_tracking_for_user(user, true)
      assert @issue_change.reload.present?
      IssueChange.turn_off_tracking_for_user(user, false)
      assert IssueChange.find_by_id(@issue_change.id).nil?
    end
  end
end
