module IssueChangeMonitor
  module Hooks
    class ViewIssuesIndexBottomHook < Redmine::Hook::ViewListener
       # Adds javascript and stylesheet tags
       def view_issues_index_bottom(context)
         if User.current.logged?
           javascript_include_tag('issue_change_monitor.js', :plugin => :issue_change_monitor) +
           stylesheet_link_tag('issue_change_monitor.css', :plugin => :issue_change_monitor)
         end
       end
    end
  end
end