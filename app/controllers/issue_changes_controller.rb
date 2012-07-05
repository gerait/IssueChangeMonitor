class IssueChangesController < ApplicationController
  unloadable
  before_filter :require_login
  
  respond_to :json, :only => [:check]
  respond_to :js, :only => [:check_all]

  # For separate request per each issue
  def check
    @label, @css_class = IssueChange.change_label_for(User.current, params[:issue_id])
    respond_to do |format|
      format.json { render :json => {:label => @label, :css_class => @css_class}.to_json }
    end
  end
  
  def check_all
    project = Project.find_by_id(params[:project_id])
    if project.present?
      member = Member.find_by_project_id_and_user_id(project.id, User.current.id) 
      @issue_changes_labels = IssueChange.all_change_label_for(member, params[:issue_ids])
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
