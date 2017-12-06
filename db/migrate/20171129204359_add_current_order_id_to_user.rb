class AddCurrentOrderIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :current_order_id, :string
  end
end
