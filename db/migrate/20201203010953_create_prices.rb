class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices, id: :uuid do |t|
      t.references :item, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :nsuid, null: false
      t.monetize :regular_price
      t.monetize :discount_price, amount: { null: true, default: nil }
      t.datetime :discount_start_date
      t.datetime :discount_end_date
      t.string :state, null: false
      t.integer :discount_percentage
      t.jsonb :data, default: {}

      t.timestamps
    end

    add_index :prices, :nsuid, unique: true
  end
end
