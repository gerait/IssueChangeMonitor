
require 'redmine'

# Patches to the Redmine core.
# require 'issue_change_monitor/patches/users_controllers_patch'
# Rails.configuration.to_prepare do
#   Issue.send(:include, IssueChangeMonitor::Patches::UsersControllerPatch) unless Issue.included_modules.include? IssueChangeMonitor::Patches::UsersControllerPatch
# end

require 'issue_change_monitor/hooks/view_issues_index_bottom_hook'

Redmine::Plugin.register :issue_change_monitor do
  name 'Issue Change Monitor plugin'
  author 'Mihail Skvirskiy'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  
end
