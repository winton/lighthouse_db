ActiveAdmin.register GithubUser do

  filter :login
  filter :name
  filter :org
  filter :token

  permit_params :login, :org, :token

  index do
    column :login
    column :name
    column :org
    column :token
    default_actions
  end

  form do |f|
    f.inputs "Github User" do
      f.input :login, :label => "Github Login"
      f.input :org,   :label => "Github Org"
      f.input :token, :label => "Github Token"
    end
    f.actions
  end
end
