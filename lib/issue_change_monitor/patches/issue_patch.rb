module IssueChangeMonitor
  module Patches
    module IssuePatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          after_update :update_issue_change
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        protected
        
        def update_issue_change
          IssueChange.where(:issue_id => self.id).update_all({:updated => true}) if self.changed?
          #p self..any?{|i| i.changed? || i.new_record? || i.marked_for_destruction? }
        end
      end
    end
  end
end