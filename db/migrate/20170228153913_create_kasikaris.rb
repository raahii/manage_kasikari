class CreateKasikaris < ActiveRecord::Migration[5.0]
  def change
    create_table :kasikaris do |t|
      t.integer :item_id, null: false
      t.integer :from_user_id, null: false
      t.integer :to_user_id, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :done_flag, default: false, null: false

      t.timestamps
    end
  end
end
