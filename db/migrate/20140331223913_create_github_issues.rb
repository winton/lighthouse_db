class CreateGithubIssues < ActiveRecord::Migration
  def change
    create_table :github_issues do |t|
      t.integer :number
      t.string  :repo
      t.string  :state
      t.string  :title
      t.string  :url,  limit: 256
      t.string  :body, limit: 20480
      
      t.integer :assigned_github_user_id
      t.integer :github_user_id

      t.datetime :issue_created_at
      t.datetime :issue_updated_at
      t.datetime :issue_closed_at
      
      t.timestamps

      t.index :number
      t.index :repo
      t.index :state
      t.index :url

      t.index :assigned_github_user_id
      t.index :github_user_id
    end
  end
end
