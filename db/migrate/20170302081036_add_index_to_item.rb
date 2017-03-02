class AddIndexToItem < ActiveRecord::Migration[5.0]
  def change
    add_index :items, [:user_id, :created_at]
  end
end
