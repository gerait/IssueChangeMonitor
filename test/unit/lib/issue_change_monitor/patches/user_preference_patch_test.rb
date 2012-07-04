require File.expand_path('../../../../../test_helper', __FILE__)

class IssuePatchTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences
    
  context "show_issue_change_labels" do
    should "return set show_issue_change_labels flag" do
      user = User.find 2
      preference = UserPreference.new(:user => user)
      preference[:show_issue_change_labels] = true
      assert preference.show_issue_change_labels
    end
    should "return 0 by default" do
      user = User.find 2
      preference = UserPreference.new(:user => user)
      assert '0', preference.show_issue_change_labels
    end
  end
  
  context "show_issue_change_labels=" do
    should "set show_issue_change_labels flag" do
      user = User.find 2
      preference = UserPreference.new(:user => user)
      preference.show_issue_change_labels = true
      assert preference[:show_issue_change_labels]
    end
  end
  
  context "show_issue_change_labels?" do
    should "return true if value '1' and false in other case" do
      user = User.find 2
      preference = UserPreference.new(:user => user)
      preference[:show_issue_change_labels] = '1'
      assert preference.show_issue_change_labels?
      
      preference[:show_issue_change_labels] = '0'
      assert !preference.show_issue_change_labels?
    end
  end
end
