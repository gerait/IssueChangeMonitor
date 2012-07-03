class IssueChangesController < ApplicationController
  unloadable
  before_filter :require_login
  
  respond_to :json, :only => [:check]

  def check
    @label, @css_class = IssueChange.change_label_for(User.current, params[:issue_id])
    respond_to do |format|
      format.json { render :json => {:label => @label, :css_class => @css_class}.to_json }
    end
  end

end
