class CreateUserFactories < ActiveRecord::Migration[8.1]
  def change
    create_table :user_factories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :factory, null: false, foreign_key: true
      t.string :role, null: false

      t.timestamps
    end

    add_index :user_factories, [ :user_id, :factory_id ], unique: true
  end
end
