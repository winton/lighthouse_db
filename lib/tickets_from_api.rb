class TicketsFromApi < Struct.new(:project_id, :user)

  def create_tickets(lighthouse, tickets, tickets_hash)
    tickets.each do |ticket|
      
      api_ticket   = tickets_hash[ticket[:number]]
      ticket       = TicketFromApi.new(api_ticket, ticket).update
      ticket.token = user.token

      CreateLighthouseUsers.new(ticket, ticket.namespace).create_users
      
      ticket.save

      UpdateLighthouseEvents.new(ticket, lighthouse, project_id).update
    end
  end

  def hash_tickets_by_number(tickets)
    numbers = tickets.collect { |t| t[:number] }
    tickets = LighthouseTicket.where(number: numbers)
    Hash[tickets.map { |t| [ t.number, t ] }]
  end

  def next_page?(tickets, tickets_hash)
    if tickets.last
      last_ticket = tickets_hash[tickets.last[:number]]

      if last_ticket
        last_ticket.needs_update?(tickets.last)
      else
        true
      end
    end
  end

  def recently_updated_tickets(page, limit)
    [
      lighthouse = Lighthouse.new(user),
      lighthouse.recently_updated_tickets(project_id, page, limit)
    ]
  end

  def update(page=1, limit=100)
    puts "Processing page #{page}..." unless Rails.env == "test"

    lighthouse, tickets = recently_updated_tickets(page, limit)
    tickets_hash        = hash_tickets_by_number(tickets)
    
    create_tickets(lighthouse, tickets, tickets_hash)

    if next_page?(tickets, tickets_hash)
      update(page + 1, limit)
    end
  end
end