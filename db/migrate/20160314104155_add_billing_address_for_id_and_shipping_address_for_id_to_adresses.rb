class AddBillingAddressForIdAndShippingAddressForIdToAdresses < ActiveRecord::Migration
  def change
  	add_column :addresses, :billing_address_id, :integer, index: true
    add_column :addresses, :shipping_address_id, :integer, index: true
  end
end
