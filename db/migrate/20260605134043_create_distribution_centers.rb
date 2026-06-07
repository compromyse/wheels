class CreateDistributionCenters < ActiveRecord::Migration[8.1]
  def change
    create_table :distribution_centers do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
