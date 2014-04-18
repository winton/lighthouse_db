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
      order('commits desc')

    if params[:logins]
      @issues = @issues.
        joins(:github_user).
        where(github_users: { login: params[:logins].keys })
    end

    @users_by_team = GithubUser.group_by_team
  end
end
