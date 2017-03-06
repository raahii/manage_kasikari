class AddFlagToKasikari < ActiveRecord::Migration[5.0]
  def change
    add_column :kasikaris, :flag, :integer, default: 0
    add_index :kasikaris, [:from_user_id, :status, :flag]
  end
end
