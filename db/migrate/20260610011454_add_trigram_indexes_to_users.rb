class AddTrigramIndexesToUsers < ActiveRecord::Migration[8.1]
  def up
    enable_extension "pg_trgm"
    add_index :users, :name,  using: :gin, opclass: :gin_trgm_ops, name: "index_users_on_name_trgm"
    add_index :users, :email, using: :gin, opclass: :gin_trgm_ops, name: "index_users_on_email_trgm"
  end

  def down
    remove_index :users, name: "index_users_on_name_trgm"
    remove_index :users, name: "index_users_on_email_trgm"
    disable_extension "pg_trgm"
  end
end
