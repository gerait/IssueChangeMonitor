class IssueChange < ActiveRecord::Base
  unloadable
  
  belongs_to :issue
  belongs_to :member
  
  validates_presence_of :issue
  validates_presence_of :member
  validates_uniqueness_of :issue_id, :scope => :member_id
  
  scope :with_issue_id, lambda{|issue_id| where(issue_id.present? ? {:issue_id => issue_id} : 'FALSE')}
  scope :with_member_id, lambda{|member_id| where(member_id.present? ? {:member_id => member_id} : 'FALSE')}

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
  
  # For separate request per each issue
  def self.change_label_for(user, issue_id)
    label = []
    issue = Issue.find_by_id(issue_id)
    member = Member.where(:user_id => user.id, :project_id => issue.project_id).first if issue
    if user.present? && issue.present? && member.present? && issue.updated_on >= member.created_on
      issue_change = IssueChange.with_issue_id(issue_id).with_member_id(user.members).first
      label = if issue_change.blank?
        ["New", 'new_issue_change_label']
      elsif issue_change.updated?
        ["Updated", 'update_issue_change_label']
      else
        []
      end
    end
    label
  end

  def self.all_change_label_for(member, issue_ids)
    labels = {}
    passed_ids = issue_ids.reject(&:blank?)
    if passed_ids.present? && member.present?
      ids = Issue.where(["id IN(?) AND updated_on >= ?", passed_ids, member.created_on]).map(&:id)
      issue_changes = IssueChange.with_issue_id(ids).with_member_id(member).index_by(&:issue_id)
      ids.each do |id|
        change = issue_changes[id]
        if change.blank?
          labels[id] = ["New", 'new_issue_change_label']
        elsif change.updated?
          labels[id] = ["Updated", 'update_issue_change_label']
        end
      end
    end
    labels
  end
end
