module IssueChangeMonitor
  module Patches
    module MemberPatch
      
      extend ActiveSupport::Concern
      
      included do      
        unloadable
        before_destroy :delete_issue_changes
      end

      protected
        
      def delete_issue_changes
        IssueChange.where(:member_id => self.id).delete_all
      end
    end
  end
end