class CreateCartedProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :carted_products do |t|
      t.string :product_id
      t.integer :quantity
      t.string :type
      t.integer :amount
      t.string :name
      t.string :status
      t.integer :customer_id
      t.string :option

      t.timestamps
    end
  end
end
