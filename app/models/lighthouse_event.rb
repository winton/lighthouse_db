class LighthouseEvent < ActiveRecord::Base
  
  attr_accessor :assigned_lighthouse_id, :lighthouse_id, :token

  belongs_to :lighthouse_ticket
  belongs_to :assigned_lighthouse_user, :class_name => 'LighthouseUser'
  belongs_to :lighthouse_user
end
