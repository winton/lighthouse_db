class TicketsFromApi < Struct.new(:project_id, :user)

  def hash_tickets_by_numbers(numbers)
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

  def update(page=1, limit=100)
    puts "Processing page #{page}..." unless Rails.env == "test"

    lighthouse   = Lighthouse.new(user)
    tickets      = lighthouse.recently_updated_tickets(project_id, page, limit)
    numbers      = tickets.collect { |t| t[:number] }
    tickets_hash = hash_tickets_by_numbers(numbers)
    
    tickets.each do |ticket|
      ticket       = TicketFromApi.new(tickets_hash[ticket[:number]], ticket).update
      ticket.token = user.token

      CreateLighthouseUsers.new(ticket, ticket.namespace).create_users
      
      ticket.save

      UpdateLighthouseEvents.new(ticket, lighthouse, project_id).update
    end

    if next_page?(tickets, tickets_hash)
      update(page + 1, limit)
    end
  end
end