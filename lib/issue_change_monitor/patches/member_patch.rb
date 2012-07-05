module IssueChangeMonitor
  module Patches
    module MemberPatch
      extend ActiveSupport::Concern
      
      included do      
        unloadable
        has_many :issue_changes, :dependent => :delete_all
      end
    end
  end
end