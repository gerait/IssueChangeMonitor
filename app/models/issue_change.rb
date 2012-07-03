class IssueChange < ActiveRecord::Base
  unloadable
  
  belongs_to :issue
  belongs_to :member
  
  validates_presence_of :issue
  validates_presence_of :member
  validates_uniqueness_of :issue_id, :scope => :member_id
  
  scope :with_issue_id, lambda{|issue_id| where(issue_id.present? ? {:issue_id => issue_id} : 'FALSE')}
  scope :with_member_ids, lambda{|member_ids| where(member_ids.present? ? {:member_id => member_ids} : 'FALSE')}

  def self.mark_as_viewed_or_create(user, issue)
    member = Member.where(:user_id => user.id, :project_id => issue.project_id).first
    if member
      issue_change = IssueChange.where({:issue_id => issue.id, :member_id => member.id}).first
      if issue_change.blank?
        IssueChange.create({:issue_id => issue.id, :member_id => member.id, :updated => false})
      else
        issue_change.update_attribute(:updated, false) if issue_change.updated
      end
    end
  end
  
  def self.change_label_for(user, issue_id)
    label = []
    if user.present?
      issue_change = IssueChange.with_issue_id(issue_id).with_member_ids(user.members).first
      label = if issue_change.blank?
        ["[New]", 'new_issue_change_label']
      elsif issue_change.updated?
        ["[Updated]", 'update_issue_change_label']
      else
        []
      end
    end
    label
  end

end
