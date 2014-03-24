# require 'persist_changes'

class LighthouseUser < ActiveRecord::Base

  # include PersistChanges

  # after_commit :update_lighthouse_id
  # after_save   :update_lighthouse_id if Rails.env == 'test'

  # after_commit :remove_dups
  # after_save   :remove_dups if Rails.env == 'test'

  has_many :assigned_lighthouse_tickets, :class_name => 'LighthouseTicket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_tickets

  def remove_dups
    LighthouseUser.where(<<-SQL, namespace, token, id).delete_all
      namespace = ? AND token = ? AND id <> ?
    SQL
  end

  def update_from_api!(project_id, page=1, limit=100)
    @api_tickets  = Lighthouse.new(self).recently_updated_tickets(project_id, page, limit)
    @tickets_hash = LighthouseTicket.hash_tickets_by_numbers(
      @api_tickets.collect { |t| t[:number] }
    )
    
    @api_tickets.each do |api_ticket|
      update_ticket_from_api(api_ticket)
    end

    update_from_api!(project_id, page + 1, limit)  if next_page?
  end

  def update_lighthouse_id
    return if lighthouse_id || !namespace
    reset_changes # makes test env same as production

    self.lighthouse_id = Lighthouse.new(self).user[:id]
    update_all_changes
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
    attributes = LighthouseTicket.to_attributes(api_ticket)
    
    if ticket
      ticket.assign_attributes(attributes)
    else
      ticket = lighthouse_tickets.build(attributes)
    end

    ticket.save
  end
end
