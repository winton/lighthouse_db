class CreateLighthouseEvents < ActiveRecord::Migration
  def change
    create_table :lighthouse_events do |t|
      t.string   :event
      t.string   :body, limit: 40960
      t.string   :milestone
      t.string   :state
      t.integer  :assigned_lighthouse_user_id
      t.integer  :lighthouse_ticket_id
      t.integer  :lighthouse_user_id
      t.datetime :happened_at
      t.timestamps

      t.index :event
      t.index :state
      t.index :assigned_lighthouse_user_id
      t.index :lighthouse_ticket_id
    end
  end
end
