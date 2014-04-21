class ShippedController < ApplicationController

  def index
    start_end
    issues
    code_review_events
    code_review_names
    code_review_counts
    users_by_team
  end

  private

  def start_end
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
  end

  def issues
    @issues = GithubIssue.
      where("issue_updated_at > ?", @start).
      where(state: "closed", merged: true).
      includes(:lighthouse_ticket).
      order('commits desc')

    if params[:logins]
      @issues = @issues.
        joins(:github_user).
        where(github_users: { login: params[:logins].keys })
    end
  end

  def code_review_events
    @code_review_events = @issues.collect { |i|
      if i.lighthouse_ticket
        i.lighthouse_ticket.lighthouse_events.where(event: 'state', state: 'pending-qa')
      else
        []
      end
    }.flatten
  end

  def code_review_names
    @code_review_names = @code_review_events.collect do |e|
      e.lighthouse_user.formatted_name
    end.uniq.sort
  end

  def code_review_counts
    @code_review_counts = Array.new(@code_review_names.length, 0)
    @code_review_events.each do |e|
      index = @code_review_names.index(e.lighthouse_user.formatted_name)
      @code_review_counts[index] += 1
    end
  end

  def users_by_team
    @users_by_team = GithubUser.group_by_team
  end
end
