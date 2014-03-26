class LighthouseTicket < ActiveRecord::Base
  
  attr_accessor :assigned_lighthouse_id, :lighthouse_id

  belongs_to :assigned_lighthouse_user, :class_name => 'LighthouseUser'
  belongs_to :lighthouse_user

  before_save do |ticket|
    if ticket.assigned_lighthouse_id
      ticket.assigned_lighthouse_user = LighthouseUser.where(
        lighthouse_id: ticket.assigned_lighthouse_id,
        namespace:     ticket.namespace
      ).first_or_initialize

      ticket.assigned_lighthouse_user.update_name_and_job!(token)
    end

    if ticket.lighthouse_id
      ticket.lighthouse_user = LighthouseUser.where(
        lighthouse_id: ticket.lighthouse_id,
        namespace:     ticket.namespace
      ).first_or_initialize

      ticket.lighthouse_user.update_name_and_job!(token)
    end
  end

  def namespace
    self.url.match(/\/\/([^\.]+)/)[1] rescue nil
  end

  def needs_update?(api_ticket)
    ticket_updated_at != Time.parse(api_ticket[:updated_at])
  end

  class <<self

    def hash_tickets_by_numbers(numbers)
      Hash[ LighthouseTicket.where(number: numbers).map { |t| [ t.number, t ] } ]
    end

    def to_attributes(t, token)
      {
        assigned_lighthouse_id: t[:assigned_user_id],
        body:                   t[:original_body_html],
        lighthouse_id:          t[:creator_id],
        number:                 t[:number],
        state:                  t[:state],
        ticket_created_at:      t[:created_at],
        ticket_updated_at:      t[:updated_at],
        title:                  t[:title],
        token:                  token,
        url:                    t[:url]
      }
    end
  end
end
