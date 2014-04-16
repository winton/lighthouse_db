class ShippedController < ApplicationController

  def index
    if params[:start]
      @start = DateTime.strptime(params[:start], "%m/%d/%Y")
    else
      @start = DateTime.now.last_week(:friday)
    end
    if params[:end]
      @end = DateTime.strptime(params[:end], "%m/%d/%Y")
    else
      @end = DateTime.now
    end

    @issues = GithubIssue.
      where("issue_updated_at > ?", @start).
      where(state: "closed", merged: true).
      includes(:github_user).
      order('commits desc')

    @users_by_team = GithubUser.group_by_team
  end
end
