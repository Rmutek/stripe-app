class RenameTypeInCartedProductsToProductType < ActiveRecord::Migration[5.1]
  def change
    rename_column :carted_products, :type, :product_type
  end
end
