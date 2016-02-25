class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.decimal   :total_price
    	t.date 			:completed_date
    	t.integer		:state, default: 1
    	t.string 		:billing_address
    	t.string 		:shipping_address
      t.belongs_to :customer, index:true
      t.belongs_to :credit_card, index:true

      t.timestamps null: false
    end
  end
end
