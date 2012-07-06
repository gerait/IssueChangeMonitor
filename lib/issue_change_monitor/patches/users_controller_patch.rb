module IssueChangeMonitor
  module Patches
    module UsersControllerPatch
      
      extend ActiveSupport::Concern
      
      included do      
        unloadable
        alias_method_chain :create, :ext
        alias_method_chain :update, :ext
      end
      
      def create_with_ext
        create_without_ext
        unless @user.id.nil?
          @user.pref.show_issue_change_labels = (params[:pref] && params[:pref][:show_issue_change_labels] == '1')
          @user.pref.save
        end
      end

      def update_with_ext
        show_issue_change_labels = (params[:pref] && params[:pref][:show_issue_change_labels] == '1')
        @user.pref.show_issue_change_labels = show_issue_change_labels
        update_without_ext
      end
    end
  end
end