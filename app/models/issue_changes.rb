class IssueChanges < ActiveRecord::Base
  unloadable
  
  belongs_to :issue
  belongs_to :member
  
  scope :with_issue_id, lambda{|issue_id| where(issue_id.present? ? {:issue_id => issue_id} : 'FALSE')}
  scope :with_member_id, lambda{|member_id| where(member_id.present? ? {:member_id => member_id} : 'FALSE')}
  

end
