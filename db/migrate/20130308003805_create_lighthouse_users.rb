class CreateLighthouseUsers < ActiveRecord::Migration
  def change
    create_table :lighthouse_users do |t|
      t.string  :job
      t.string  :name
      t.string  :namespace
      t.string  :token
      t.integer :lighthouse_id

      t.timestamps

      t.index :job
      t.index :name
      t.index :namespace
      t.index :token
      t.index :lighthouse_id
    end
  end
end
