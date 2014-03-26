class LighthouseUser < ActiveRecord::Base

  has_many :assigned_lighthouse_tickets, :class_name => 'LighthouseTicket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_tickets

  def update_name_and_job!(token)
    unless self.job || self.name
      lh = Lighthouse.new(self, token).user
      self.job  = lh[:job]
      self.name = lh[:name]
    end

    save
  end

  def update_from_api!(project_id, page=1, limit=100)
    puts "Processing page #{page}..." unless Rails.env == "test"

    @api_tickets  = Lighthouse.new(self).recently_updated_tickets(project_id, page, limit)
    @tickets_hash = LighthouseTicket.hash_tickets_by_numbers(
      @api_tickets.collect { |t| t[:number] }
    )
    
    @api_tickets.each do |api_ticket|
      update_ticket_from_api(api_ticket)
    end

    update_from_api!(project_id, page + 1, limit)  if next_page?
  end

  private

  def next_page?
    if @api_tickets.last
      last_ticket = @tickets_hash[@api_tickets.last[:number]]

      if last_ticket
        last_ticket.needs_update?(@api_tickets.last)
      else
        true
      end
    end
  end

  def update_ticket_from_api(api_ticket)
    ticket     = @tickets_hash[api_ticket[:number]]
    attributes = LighthouseTicket.to_attributes(api_ticket, token)
    
    if ticket
      ticket.assign_attributes(attributes)
    else
      ticket = lighthouse_tickets.build(attributes)
    end

    ticket.create_lighthouse_users
    ticket.save
  end
end
