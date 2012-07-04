module IssueChangeMonitor
  module Patches
    module IssuesControllerPatch
      extend ActiveSupport::Concern
      
      included do      
        unloadable
        append_before_filter :update_issue_change, :only => [:show, :edit]
      end

      protected
      def update_issue_change
        IssueChange.mark_as_viewed_or_create(User.current, @issue) if User.current.logged? && User.current.pref.show_issue_change_labels? && @issue.present?
      end
    end
  end
end