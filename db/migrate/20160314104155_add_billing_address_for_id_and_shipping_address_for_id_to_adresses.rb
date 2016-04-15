class AddBillingAddressForIdAndShippingAddressForIdToAdresses < ActiveRecord::Migration
  def change
    add_column :addresses, :user_billing_address_id, :integer, index: true
    add_column :addresses, :user_shipping_address_id, :integer, index: true
    add_column :addresses, :order_billing_address_id, :integer, index: true
    add_column :addresses, :order_shipping_address_id, :integer, index: true
  end
end
