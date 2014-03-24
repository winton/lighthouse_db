class CreateLighthouseTickets < ActiveRecord::Migration
  def change
    create_table :lighthouse_tickets do |t|
      t.integer :number
      t.string  :state
      t.string  :title
      t.string  :url,  limit: 256
      t.string  :body, limit: 20480

      t.integer :assigned_lighthouse_user_id
      t.integer :lighthouse_user_id

      t.datetime :ticket_created_at
      t.datetime :ticket_updated_at

      t.timestamps

      t.index :number
      t.index :assigned_lighthouse_user_id
      t.index :lighthouse_user_id
    end
  end
end
