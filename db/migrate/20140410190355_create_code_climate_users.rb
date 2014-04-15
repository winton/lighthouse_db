class CreateCodeClimateUsers < ActiveRecord::Migration
  def change
    create_table :code_climate_users do |t|
      t.string :login
      t.string :password
      t.timestamps
    end
  end
end
