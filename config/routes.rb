# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'issue_changes/check', :to => 'issue_changes#check'
post 'issue_changes/check_all', :to => 'issue_changes#check_all'