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
          IssueChange.where(:issue_id => self.journalized.id).update_all({:updated => true}) if self.changed? && self.journalized.is_a?(Issue)
        rescue
        end
      end
    end
  end
end