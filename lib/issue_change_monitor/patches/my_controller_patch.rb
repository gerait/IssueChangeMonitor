module IssueChangeMonitor
  module Patches
    module MyControllerPatch
      
      extend ActiveSupport::Concern
      
      included do      
        unloadable
        alias_method_chain :account, :ext
      end
      
      def account_with_ext
        if request.post?
          show_issue_change_labels = (params[:show_issue_change_labels] == '1')
          IssueChange.turn_off_tracking_for_user(User.current, show_issue_change_labels)
          User.current.pref.show_issue_change_labels = show_issue_change_labels
        end
        account_without_ext
      end
    end
  end
end