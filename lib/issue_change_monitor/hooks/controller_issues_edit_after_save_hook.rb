module IssueChangeMonitor
  module Hooks
    class ControllerIssuesEditAfterSaveHook < Redmine::Hook::ViewListener
       def controller_issues_edit_after_save(context)
         begin
           IssueChange.mark_as_viewed_or_create(context[:time_entry].try(:user) || context[:journal].try(:user), context[:issue])
         rescue
         end
       end
    end
  end
end