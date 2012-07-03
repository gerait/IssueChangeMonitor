#!/usr/bin/env ruby
plugin_support'

Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'redmine_issue_change_monitor'
  plugin.default_task = [:test]
  plugin.tasks = [:db, :doc, :clean, :test]
  plugin.redmine_root = File.expand_path(File.dirname(__FILE__) + '/../../../')
end