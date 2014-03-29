ActiveAdmin.register LighthouseEvent do

  index do
    column :lighthouse_ticket
    column :event
    column :body
    column :milestone
    column :state
    column :happened_at
    column :assigned_lighthouse_user
    default_actions
  end
end
