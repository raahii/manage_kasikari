class ChangeColumnOfKarikaris < ActiveRecord::Migration[5.0]
  def change
    remove_column :kasikaris, :done_flag
    add_column :kasikaris, :status, :integer, default: 0

    add_index :kasikaris, [:from_user_id, :status]
    add_index :kasikaris, [:to_user_id, :status]
  end
end
