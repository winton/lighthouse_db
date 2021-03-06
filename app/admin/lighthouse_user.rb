ActiveAdmin.register LighthouseUser do

  filter :job
  filter :lighthouse_id
  filter :name
  filter :namespace
  filter :token
  filter :project_id

  permit_params :namespace, :token, :lighthouse_id, :project_id

  index do
    column :job
    column :lighthouse_id
    column :project_id
    column :name
    column :namespace
    column :token
    default_actions
  end

  form do |f|
    f.inputs "Lighthouse User" do
      f.input :namespace,     :label => "Project Namespace (xxx.lighthouseapp.com)"
      f.input :token,         :label => "API Token"
      f.input :lighthouse_id, :label => "Lighthouse User ID"
      f.input :project_id,    :label => "Lighthouse Project ID"
    end
    f.actions
  end
end
