module IssueChangeMonitor
  module Patches
    module JournalPatch
      
      extend ActiveSupport::Concern
      
      included do
        unloadable
        after_save :update_issue_change
      end

      protected
        
      def update_issue_change
        IssueChange.where(:issue_id => self.journalized.id).update_all({:updated => true}) if self.changed? && self.journalized.is_a?(Issue)
      end
    end
  end
end