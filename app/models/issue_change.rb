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
      issue_change = IssueChange.with_issue_id(issue_id).with_member_id(member.id).first
      label = if issue_change.blank?
        #Old issues, which created before member created mark as Updated
        issue.created_on >= member.created_on ? ["New", 'new_issue_change_label'] : ["Updated", 'update_issue_change_label']
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
      issues = Issue.where(["id IN(?) AND updated_on >= ?", passed_ids, member.created_on])
      issue_changes = IssueChange.with_issue_id(issues.map(&:id)).with_member_id(member.id).index_by(&:issue_id)
      issues.each do |issue|
        change = issue_changes[issue.id]
        if change.blank?
          #Old issues, which created before member created mark as Updated
          labels[issue.id] = issue.created_on >= member.created_on ? ["New", 'new_issue_change_label'] : ["Updated", 'update_issue_change_label']
        elsif change.updated?
          labels[issue.id] = ["Updated", 'update_issue_change_label']
        end
      end
    end
    labels
  end
  
  def self.sql_all_change_label_for(user, issue_ids)
    labels = {}
    passed_ids = issue_ids.reject(&:blank?)
    if passed_ids.present? && user.present?
      changes = Issue.find_by_sql(%Q!
          SELECT IF(issue_changes.id IS NULL, 
                    IF(issues.created_on >= members.created_on, "New", "Updated"), 
                    IF(issue_changes.updated, "Updated", NULL)) as label, 
                  issues.id
          FROM issues
          INNER JOIN projects ON projects.id = issues.project_id 
          INNER JOIN members ON projects.id = members.project_id
          LEFT JOIN issue_changes ON issue_changes.issue_id = issues.id AND issue_changes.member_id = members.id
          WHERE issues.updated_on >= members.created_on AND members.user_id = #{user.id} AND issues.id IN(#{passed_ids.join(",")})
        !)
      changes.each do |c|
        labels[c.id] = (c.label == "New" ? ["New", 'new_issue_change_label'] : ["Updated", 'update_issue_change_label']) if c.label.present?
      end
    end
    labels
  end
  
  #Not use now
  def self.turn_off_tracking_for_user(user, show_issue_change_label)
    turn_off = user.pref.show_issue_change_labels? && !show_issue_change_label
    IssueChange.where(:member_id => user.members.map(&:id)).delete_all if turn_off
  end
end
