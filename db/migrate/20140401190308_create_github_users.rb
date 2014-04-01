class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.string  :login
      t.string  :name
      t.string  :org
      t.string  :token

      t.timestamps

      t.index :login
      t.index :name
      t.index :org
      t.index :token
    end
  end
end
