class CreateUserDistributionCenters < ActiveRecord::Migration[8.1]
  def change
    create_table :user_distribution_centers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :distribution_center, null: false, foreign_key: true
      t.string :role, null: false

      t.timestamps
    end

    add_index :user_distribution_centers, [ :user_id, :distribution_center_id ], unique: true
  end
end
