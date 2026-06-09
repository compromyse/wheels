class RenameFactoryTables < ActiveRecord::Migration[8.1]
  def change
    rename_table :factories, :productions
    rename_table :user_factories, :user_productions

    rename_column :user_productions, :factory_id, :production_id
    rename_column :bike_requests, :factory_id, :production_id
  end
end
