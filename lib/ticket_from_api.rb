class TicketFromApi < Struct.new(:ticket, :api_ticket)

  def to_attributes(t)
    {
      assigned_lighthouse_id: t[:assigned_user_id],
      body:                   t[:original_body_html],
      lighthouse_id:          t[:creator_id],
      milestone:              t[:milestone_title],
      number:                 t[:number],
      state:                  t[:state],
      ticket_created_at:      t[:created_at],
      ticket_updated_at:      t[:updated_at],
      title:                  t[:title],
      url:                    t[:url]
    }
  end

  def update
    ticket ||= LighthouseTicket.new

    attributes = to_attributes(api_ticket)  
    ticket.assign_attributes(attributes)
    ticket
  end
end