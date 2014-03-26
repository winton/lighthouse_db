class LighthouseUser < ActiveRecord::Base

  has_many :assigned_lighthouse_tickets, :class_name => 'LighthouseTicket', :foreign_key => 'assigned_lighthouse_user_id'
  has_many :lighthouse_tickets

  def update_from_api!(token)
    unless self.job || self.name
      lh = Lighthouse.new(self, token).user
      self.job  = lh[:job]
      self.name = lh[:name]
    end

    save
  end
end
