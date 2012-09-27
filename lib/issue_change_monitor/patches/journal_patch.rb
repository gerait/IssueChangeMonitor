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
        begin
          if self.changed? && self.journalized.is_a?(Issue)
            IssueChange.where(:issue_id => self.journalized.id).update_all({:updated => true}) 
            IssueChange.mark_as_viewed_or_create(self.user, self.journalized)
          end
        rescue
        end
      end
    end
  end
end