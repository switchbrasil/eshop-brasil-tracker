class AddIndexToItemsOnNsuid < ActiveRecord::Migration[6.1]
  def change
    add_index :items, :nsuid, where: 'nsuid IS NOT NULL'
  end
end
