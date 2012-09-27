module IssueChangeMonitor
  module Patches
    module IssuePatch
      extend ActiveSupport::Concern
      
      included do      
        unloadable
        has_many :issue_changes, :dependent => :delete_all
        after_create :create_issue_change
        after_update :update_issue_change
      end

      protected
        
      def create_issue_change
        begin
          IssueChange.mark_as_viewed_or_create(self.author, self)
        rescue
        end
      end

      def update_issue_change
        begin
          IssueChange.where(:issue_id => self.id).update_all({:updated => true}) if self.changed?
        rescue
        end
      end
    end
  end
end