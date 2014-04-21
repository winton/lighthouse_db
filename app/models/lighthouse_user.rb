class LighthouseUser < ActiveRecord::Base

  has_many :assigned_lighthouse_tickets, :class_name => 'LighthouseTicket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_tickets

  def formatted_name
    u = self.name.split(/\s+/)
    if u[1]
      u[0] + " " + u[1][0..0]
    else
      u[0]
    end
  end

  class <<self
    def token_user
      where("token IS NOT NULL").first
    end
  end
end
