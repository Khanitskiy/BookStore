class AddDeliveryFromOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery, :decimal, default: 5.0
  end
end
