class ShippedController < ApplicationController

  def index
    start = DateTime.now.last_week(:friday)

    # events = LighthouseEvent.
    #   where(state: 'deployed', event: 'state').
    #   where("happened_at > ?", start).
    #   order('happened_at desc')

    # @tickets = events.map do |event|
    #   ticket = event.lighthouse_ticket
    #   users  = ticket.lighthouse_events.map do |e|
    #     e.assigned_lighthouse_user.try(:name)
    #   end
    #   users = users.compact.uniq.map do |u|
    #     u = u.split(/\s+/)
    #     if u[1]
    #       u[0] + " " + u[1][0..0]
    #     else
    #       u[0]
    #     end
    #   end
    #   [ ticket, users ]
    # end

    @issues = GithubIssue.
      where("issue_updated_at > ?", start).
      where(state: "closed").
      order('commits desc')

    puts @issues.inspect
  end
end
