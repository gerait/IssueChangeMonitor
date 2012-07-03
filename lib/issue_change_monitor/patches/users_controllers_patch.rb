# module IssueChangeMonitor
#   module Patches
#     module UsersControllerPatch
#       def self.included(base)
#         base.extend(ClassMethods)
#         base.send(:include, InstanceMethods)
#         base.class_eval do
#           unloadable
#           alias_method_chain :create, :ext
#           alias_method_chain :update, :ext
#         end
#       end
# 
#       module ClassMethods
#       end
# 
#       module InstanceMethods
#         def create_with_ext
#           create_without_ext
#           unless @user.id.nil?
#             @user.pref[:no_self_notified_closed] = (params[:no_self_notified_closed] == '1')
#             @user.pref.save
#           end
#         end
# 
#         def update_with_ext
#           @user.pref[:no_self_notified_closed] = (params[:no_self_notified_closed] == '1')
#           update_without_ext
#         end
#       end
#     end
#   end
# end