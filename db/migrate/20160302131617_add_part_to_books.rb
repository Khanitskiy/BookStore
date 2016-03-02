class AddPartToBooks < ActiveRecord::Migration
  def change
    add_column :books, :order_counter, :integer
    add_column :books, :best_seller, :boolean
  end
end
