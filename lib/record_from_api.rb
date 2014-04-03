module RecordFromApi

  def update
    self.record ||= klass.new
    attributes = to_attributes(api_record)  
    record.assign_attributes(attributes)
    record.token = user.token
    after_assign
    record
  end
end