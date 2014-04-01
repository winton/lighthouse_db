module RecordFromApi

  def update
    record ||= klass.new
    attributes = to_attributes(api_record)  
    record.assign_attributes(attributes)
    record
  end
end