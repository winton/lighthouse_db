class LighthouseTicket < ActiveRecord::Base
  
  attr_accessor :assigned_lighthouse_id, :lighthouse_id, :token

  belongs_to :assigned_lighthouse_user, :class_name => 'LighthouseUser'
  belongs_to :lighthouse_user

  has_many :lighthouse_events
  has_one  :github_issue

  def namespace
    self.url.match(/\/\/([^\.]+)/)[1] rescue nil
  end

  def needs_update?(ticket)
    ticket_updated_at != Time.parse(ticket[:updated_at])
  end

  def time_in_review
    time_in_state "pending-review"
  end

  def time_in_qa
    time_in_state "pending-qa"
  end

  def time_in_state(state)
    events = lighthouse_events.order(:happened_at)
    time   = 0
    events.each_with_index do |event, i|
      if event.state == state
        next_event = events[i+1]
        if next_event
          time += next_event.happened_at - event.happened_at
        else
          time += Time.now - event.happened_at
        end
      end
    end
    time
  end
end
