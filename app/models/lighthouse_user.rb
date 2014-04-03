class LighthouseUser < ActiveRecord::Base

  has_many :assigned_lighthouse_tickets, :class_name => 'LighthouseTicket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_tickets

  class <<self
    def token_user
      where("token IS NOT NULL").first
    end
  end
end
