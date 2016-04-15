class AddOrderTotalFromOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_total, :decimal
  end
end
