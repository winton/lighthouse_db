module RecordFromApi

  def update
    self.record ||= klass.new
    record.token  = user.token
    attributes    = to_attributes(api_record)  
    
    record.assign_attributes(attributes)
    
    after_assign
    record
  end
end