class TicketsFromApi < Struct.new(:project_id, :user)

  include RecordsFromApi

  def create(api, api_record, record)
    record       = TicketFromApi.new(api_record, record).update
    record.token = user.token

    CreateLighthouseUsers.new(record, record.namespace).create_users
    
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