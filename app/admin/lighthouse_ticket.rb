ActiveAdmin.register LighthouseTicket do

  filter :number
  filter :milestone
  filter :state
  filter :title
  filter :url
  filter :lighthouse_user
  filter :assigned_lighthouse_user
  filter :ticket_created_at
  filter :ticket_updated_at

  index do
    column :number
    column :milestone
    column :state
    column :title
    column :lighthouse_user
    column :assigned_lighthouse_user
    default_actions
  end

  sidebar "Relationships", only: [:show, :edit] do
    ul do
      li link_to("Events", admin_lighthouse_ticket_lighthouse_events_path(lighthouse_ticket))
    end
  end
end
