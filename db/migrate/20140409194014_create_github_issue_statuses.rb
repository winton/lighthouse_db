class CreateGithubIssueStatuses < ActiveRecord::Migration
  def change
    create_table :github_issue_statuses do |t|
      t.string  :description
      t.integer :number
      t.string  :state
      t.string  :target_url
      t.string  :url

      t.integer :github_issue_id
      t.integer :github_user_id

      t.datetime :status_created_at
      t.datetime :status_updated_at

      t.timestamps

      t.index :number
      t.index :state
      t.index :github_issue_id
      t.index :github_user_id
      t.index :status_created_at
      t.index :status_updated_at
    end
  end
end
