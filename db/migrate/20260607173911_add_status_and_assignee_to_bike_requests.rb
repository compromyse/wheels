class AddStatusAndAssigneeToBikeRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :bike_requests, :status, :integer, null: false, default: 0
    add_reference :bike_requests, :assignee, foreign_key: { to_table: :users }, null: true
    add_index :bike_requests, :status
  end
end
