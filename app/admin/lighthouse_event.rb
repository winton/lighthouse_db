ActiveAdmin.register LighthouseEvent do

  belongs_to :lighthouse_ticket

  index do
    column :event
    column :body
    column :milestone
    column :state
    column :happened_at
    column :assigned_lighthouse_user
    default_actions
  end
end
