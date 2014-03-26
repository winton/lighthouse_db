class LighthouseTicket < ActiveRecord::Base
  
  attr_accessor :assigned_lighthouse_id, :lighthouse_id, :token

  belongs_to :assigned_lighthouse_user, :class_name => 'LighthouseUser'
  belongs_to :lighthouse_user

  def create_lighthouse_users
    ids = [ self.assigned_lighthouse_id, self.lighthouse_id ]

    users = ids.map do |lh_id|
      attributes = { lighthouse_id: lh_id, namespace: self.namespace }
      lh_user    = LighthouseUser.where(attributes).first_or_initialize
      lh_user.update_from_api!(token)
      lh_user
    end

    self.assigned_lighthouse_user, self.lighthouse_user = users
  end

  def namespace
    self.url.match(/\/\/([^\.]+)/)[1] rescue nil
  end

  def needs_update?(ticket)
    ticket_updated_at != Time.parse(ticket[:updated_at])
  end

  class <<self

    def hash_tickets_by_numbers(numbers)
      tickets = where(number: numbers)
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

    def to_attributes(t)
      {
        assigned_lighthouse_id: t[:assigned_user_id],
        body:                   t[:original_body_html],
        lighthouse_id:          t[:creator_id],
        number:                 t[:number],
        state:                  t[:state],
        ticket_created_at:      t[:created_at],
        ticket_updated_at:      t[:updated_at],
        title:                  t[:title],
        url:                    t[:url]
      }
    end

    def update_all_from_api!(user, project_id, page=1, limit=100)
      puts "Processing page #{page}..." unless Rails.env == "test"

      lighthouse   = Lighthouse.new(user)
      tickets      = lighthouse.recently_updated_tickets(project_id, page, limit)
      numbers      = tickets.collect { |t| t[:number] }
      tickets_hash = hash_tickets_by_numbers(numbers)
      
      tickets.each do |ticket|
        ticket       = update_ticket_from_api(tickets_hash, ticket)
        ticket.token = user.token
        ticket.create_lighthouse_users
        ticket.save
      end

      if next_page?(tickets, tickets_hash)
        update_all_from_api!(user, project_id, page + 1, limit)
      end
    end

    def update_ticket_from_api(tickets_hash, api_ticket)
      ticket     = tickets_hash[api_ticket[:number]]
      ticket   ||= LighthouseTicket.new

      attributes = to_attributes(api_ticket)
      
      ticket.assign_attributes(attributes)
      ticket
    end
  end
end
