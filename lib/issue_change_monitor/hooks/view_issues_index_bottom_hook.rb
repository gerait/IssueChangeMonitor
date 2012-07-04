module IssueChangeMonitor
  module Hooks
    class ViewIssuesIndexBottomHook < Redmine::Hook::ViewListener
       # Adds javascript and stylesheet tags
       def view_issues_index_bottom(context)
         if User.current.logged? && User.current.pref.show_issue_change_labels? && (context[:project] && User.current.member_of?(context[:project]))
           hidden_field_tag('issue_change_project_id', context[:project].id) +
           javascript_include_tag('issue_change_monitor.js', :plugin => :issue_change_monitor) +
           stylesheet_link_tag('issue_change_monitor.css', :plugin => :issue_change_monitor)
         end
       end
    end
  end
end