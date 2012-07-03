class CreateIssueChanges < ActiveRecord::Migration
  def change
    create_table :issue_changes do |t|
      t.integer :issue_id
      t.integer :member_id
      t.boolean :updated, :default => true
    end
    add_index :issue_changes, :issue_id
    add_index :issue_changes, [:issue_id, :member_id], :uniq => true
  end
end
