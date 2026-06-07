class CreateBikeRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :bike_requests do |t|
      t.references :distribution_center, null: false, foreign_key: true
      t.references :factory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :phone, null: false
      t.string :requestor_name, null: false
      t.date :due_date, null: false
      t.string :recipient_name
      t.integer :bike_type, null: false
      t.integer :age
      t.string :height
      t.text :notes

      t.timestamps
    end
  end
end
