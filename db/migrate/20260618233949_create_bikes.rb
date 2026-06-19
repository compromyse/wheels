class CreateBikes < ActiveRecord::Migration[8.1]
  def change
    create_table :bikes do |t|
      t.references :bike_request, null: false, foreign_key: true
      t.string :name
      t.integer :bike_type, null: false, default: 0
      t.integer :age
      t.string :height
      t.text :notes
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
