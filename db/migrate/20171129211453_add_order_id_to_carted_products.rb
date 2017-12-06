class AddOrderIdToCartedProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :carted_products, :order_id, :string
  end
end
