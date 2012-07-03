require File.expand_path('../../test_helper', __FILE__)

class IssueChangesTest < ActiveSupport::TestCase
  fixtures :issues
  
  should belong_to(:issue)
  should belong_to(:member)
  
end
