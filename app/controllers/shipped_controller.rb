class ShippedController < ApplicationController

  def index
    start_end
    states
    issues
    code_review_events
    code_review_names
    code_review_counts
    users_by_team
    qa_state_changes
    @time_to_review = time_in_state('pending-review')
    @time_to_qa = time_in_state('pending-qa')
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

  def states
    @states = LighthouseTicket.select(:state).group(:state).order(:state).all
  end

  def issues
    @issues = GithubIssue.
      where("issue_updated_at > ?", @start).
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

  def qa_state_changes
    @qa_state_changes = (@start..@end).collect do |date|
      changes = LighthouseEvent.
        where("DATE(happened_at) = ?", date).
        where(event: 'state', state: 'pending-qa').
        group(:lighthouse_ticket_id).
        count
      total = changes.inject(0) do |num, (key, val)|
        num + val
      end
      avg = total.to_f / changes.keys.length
      avg.nan? ? 0 : avg
    end
  end

  def time_in_state(state)
    (@start..@end).collect do |date|
      issues = GithubIssue.
        where("DATE(issue_closed_at) = ?", date).
        includes(:lighthouse_ticket)
      issues = issues.select { |i| i.lighthouse_ticket }
      total = issues.inject(0) do |memo, issue|
        time_in_state = issue.lighthouse_ticket.time_in_state(state)
        memo + (time_in_state / 60 / 60)
      end
      avg = total.to_f / issues.length
      avg.nan? ? 0 : avg
    end
  end
end
