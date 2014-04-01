class TicketsFromApi < Struct.new(:project_id, :user)

  include RecordsFromApi

  def create(api, record, api_record)
    record       = TicketFromApi.new(record, api_record).update
    record.token = user.token

    UpdateLighthouseUsers.new(record, record.namespace).update
    
    record.save

    UpdateLighthouseEvents.new(record, api, project_id).update
  end

  def klass
    LighthouseTicket
  end

  def recently_updated(page, limit)
    [
      api = Lighthouse.new(user),
      api.recently_updated_tickets(project_id, page, limit)
    ]
  end
end