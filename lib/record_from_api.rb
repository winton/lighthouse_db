module RecordFromApi

  def update
    record ||= LighthouseTicket.new
    attributes = to_attributes(api_record)  
    record.assign_attributes(attributes)
    record
  end
end