module IssueChangeMonitor
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          append_before_filter :update_issue_change, :only => [:show, :edit]
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        protected
        def update_issue_change
          IssueChange.mark_as_viewed_or_create(User.current, @issue) if User.current.logged? && @issue.present?
        end
      end
    end
  end
end