module IssueChangeMonitor
  module Hooks
    class ViewUserPreferenceHook < Redmine::Hook::ViewListener
       def view_my_account(context)
         add_show_issue_change_labels_field(context)
       end
       
       def view_users_form(context)
         add_show_issue_change_labels_field(context)
       end
       
       protected
       
       def add_show_issue_change_labels_field(context)
         field = context[:hook_caller].send(:render, :partial => 'hooks/user_additional_preference', :locals => {:user => context[:user]})
          javascript_tag(%Q@
            Event.observe(window, 'load',
              function() {
                var el = $$(".splitcontentright .tabular")[0];
                if(el != undefined){
                  el.insert('#{escape_javascript(field)}'); 
                }
              });
          @)
       end
    end
  end
end