module IssueChangeMonitor
  module Patches
    module UserPreferencePatch
      
      extend ActiveSupport::Concern
      
      included do      
        unloadable
      end

      def show_issue_change_labels; self[:show_issue_change_labels] || '0'; end
      def show_issue_change_labels?; ActiveRecord::ConnectionAdapters::Column.value_to_boolean(self.show_issue_change_labels); end
      def show_issue_change_labels=(value); self[:show_issue_change_labels] = (ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value) ? '1' : '0'); end
    end
  end
end