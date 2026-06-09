class RenameDistributionCenterTables < ActiveRecord::Migration[8.1]
  def change
    rename_table :distribution_centers, :distributions
    rename_table :user_distribution_centers, :user_distributions

    rename_column :user_distributions, :distribution_center_id, :distribution_id
    rename_column :bike_requests, :distribution_center_id, :distribution_id
  end
end
