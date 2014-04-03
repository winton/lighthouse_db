class UpdateIssueRelationships < Struct.new(:record, :api)

  def update
    lh_number = record.body.match(/\/tickets\/(\d+)/)[1] rescue nil

    if lh_number
      record.lighthouse_ticket = TicketFromApi.from_number(lh_number)
    end
  end
end