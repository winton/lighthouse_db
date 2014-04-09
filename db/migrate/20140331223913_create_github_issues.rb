class CreateGithubIssues < ActiveRecord::Migration
  def change
    create_table :github_issues do |t|
      t.integer :number
      t.string  :repo
      t.string  :state
      t.string  :title
      t.string  :url,  limit: 256
      t.string  :body, limit: 40960
      t.integer :commits,        default: 0
      t.integer :file_additions, default: 0
      t.integer :file_deletions, default: 0
      t.integer :file_changes,   default: 0
      t.boolean :merged
      
      t.integer :assigned_github_user_id
      t.integer :github_user_id
      t.integer :lighthouse_ticket_id

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

      t.index :issue_created_at
      t.index :issue_updated_at
      t.index :issue_closed_at
    end
  end
end
