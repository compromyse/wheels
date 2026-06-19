class RefactorBikeRequests < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE bike_requests SET status = 0 WHERE status = 1"

    remove_column :bike_requests, :recipient_name
    remove_column :bike_requests, :bike_type
    remove_column :bike_requests, :age
    remove_column :bike_requests, :height
    remove_column :bike_requests, :notes
    remove_column :bike_requests, :assignee_id
  end

  def down
    add_column :bike_requests, :recipient_name, :string
    add_column :bike_requests, :bike_type, :integer
    add_column :bike_requests, :age, :integer
    add_column :bike_requests, :height, :string
    add_column :bike_requests, :notes, :text
    add_column :bike_requests, :assignee_id, :bigint
  end
end
