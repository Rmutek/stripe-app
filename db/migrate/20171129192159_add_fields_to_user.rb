class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_name, :string
    add_column :users, :street1, :string
    add_column :users, :street2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :integer
  end
end
