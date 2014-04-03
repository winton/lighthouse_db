class TicketFromApi < Struct.new(:api, :api_record, :record, :user)

  include RecordFromApi

  def after_assign
    UpdateLighthouseUsers.new(record, api, record.namespace).update
    record.save
    UpdateLighthouseEvents.new(record, api).update
  end

  def klass
    LighthouseTicket
  end

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

  class <<self
    def from_number(ticket_id)
      user       = LighthouseUser.token_user
      api        = Lighthouse.new(user)
      api_record = api.ticket(ticket_id)
      record     = LighthouseTicket.where(number: ticket_id).first

      self.new(api, api_record, record, user).update
    end
  end
end