
require 'redmine'

# Patches to the Redmine core.
Rails.configuration.to_prepare do
  Issue.send(:include, IssueChangeMonitor::Patches::IssuePatch) unless Issue.included_modules.include? IssueChangeMonitor::Patches::IssuePatch
  Journal.send(:include, IssueChangeMonitor::Patches::JournalPatch) unless Journal.included_modules.include? IssueChangeMonitor::Patches::JournalPatch
  Member.send(:include, IssueChangeMonitor::Patches::MemberPatch) unless Member.included_modules.include? IssueChangeMonitor::Patches::MemberPatch
  UserPreference.send(:include, IssueChangeMonitor::Patches::UserPreferencePatch) unless UserPreference.included_modules.include? IssueChangeMonitor::Patches::UserPreferencePatch
  IssuesController.send(:include, IssueChangeMonitor::Patches::IssuesControllerPatch) unless IssuesController.included_modules.include? IssueChangeMonitor::Patches::IssuesControllerPatch
  MyController.send(:include, IssueChangeMonitor::Patches::MyControllerPatch) unless MyController.included_modules.include? IssueChangeMonitor::Patches::MyControllerPatch
  UsersController.send(:include, IssueChangeMonitor::Patches::UsersControllerPatch) unless UsersController.included_modules.include? IssueChangeMonitor::Patches::UsersControllerPatch
end

require 'issue_change_monitor/hooks/view_issues_index_bottom_hook'
require 'issue_change_monitor/hooks/view_user_preference_hook'

Redmine::Plugin.register :issue_change_monitor do
  name 'Issue Change Monitor plugin'
  author 'Mihail Skvirskiy, Gera IT'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/gerait/IssueChangeMonitor'
  author_url 'https://github.com/gerait'
  requires_redmine :version_or_higher => '2.0.3'
end
