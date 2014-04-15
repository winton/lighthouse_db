ActiveAdmin.register CodeClimateUser do

  filter :login
  filter :password

  permit_params :login, :password

  index do
    column :login
    column :password
    default_actions
  end

  form do |f|
    f.inputs "Code Climate User" do
      f.input :login,    :label => "Code Climate Login"
      f.input :password, :label => "Code Climate Password"
    end
    f.actions
  end
end
