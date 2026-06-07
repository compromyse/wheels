class CreateBikeRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :bike_requests do |t|
      t.references :distribution_center, null: false, foreign_key: true
      t.references :factory, null: false, foreign_key: true
      t.string :organization_name, null: false
      t.string :phone, null: false
      t.string :contact_name, null: false
      t.string :contact_email, null: false
      t.string :requestor_name, null: false
      t.date :due_date, null: false

      t.timestamps
    end
  end
end
