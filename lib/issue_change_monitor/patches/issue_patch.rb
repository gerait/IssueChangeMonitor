module IssueChangeMonitor
  module Patches
    module IssuePatch
      extend ActiveSupport::Concern
      
      included do      
        unloadable
        has_many :issue_changes, :dependent => :delete_all
        after_update :update_issue_change
      end

      protected
        
      def update_issue_change
        IssueChange.where(:issue_id => self.id).update_all({:updated => true}) if self.changed?
      end
    end
  end
end