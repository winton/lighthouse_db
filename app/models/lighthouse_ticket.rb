require 'create_lighthouse_users'

class LighthouseTicket < ActiveRecord::Base
  
  attr_accessor :assigned_lighthouse_id, :lighthouse_id, :token

  belongs_to :assigned_lighthouse_user, :class_name => 'LighthouseUser'
  belongs_to :lighthouse_user

  has_many :lighthouse_events

  def namespace
    self.url.match(/\/\/([^\.]+)/)[1] rescue nil
  end

  def needs_update?(ticket)
    ticket_updated_at != Time.parse(ticket[:updated_at])
  end
end
