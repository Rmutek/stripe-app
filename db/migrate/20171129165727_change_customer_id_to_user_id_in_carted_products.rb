class ChangeCustomerIdToUserIdInCartedProducts < ActiveRecord::Migration[5.1]
  def change
    rename_column :carted_products, :customer_id, :user_id
  end
end
