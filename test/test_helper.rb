# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require 'shoulda'
require 'shoulda-matchers'

#Load plugin fixtures
all_fixtures = Dir.glob("#{File.dirname(__FILE__)}/fixtures/*.yml").collect { |f|  File.basename(f).gsub(/\.yml$/, "").to_sym }
ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/', all_fixtures)
