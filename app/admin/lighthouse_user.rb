ActiveAdmin.register LighthouseUser do

  permit_params :namespace, :token, :lighthouse_id

  form do |f|
    f.inputs "Lighthouse User" do
      f.input :namespace, :label => "Project namespace (xxx.lighthouseapp.com)"
      f.input :token, :label => "API token"
      f.input :lighthouse_id, :label => "Lighthouse user ID"
    end
    f.actions
  end
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
