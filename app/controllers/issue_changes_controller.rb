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
    #Through direct sql
    @issue_changes_labels = IssueChange.sql_all_change_label_for(User.current, params[:issue_ids])
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
