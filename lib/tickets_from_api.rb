class TicketsFromApi < Struct.new(:user)

  include RecordsFromApi

  def create(api, record, api_record)
    TicketFromApi.new(api, api_record, record, user).update
  end

  def klass
    LighthouseTicket
  end

  def recently_updated(page, limit)
    [
      api = Lighthouse.new(user),
      api.recently_updated_tickets(page, limit)
    ]
  end
end