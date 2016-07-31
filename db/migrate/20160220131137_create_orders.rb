class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.decimal   :total_price
    	t.date 			:completed_date
    	t.integer		:state, default: 1
      t.integer   :book_count
      t.integer   :step_number, default: 0
    	#t.string 		:billing_address_id
    	#t.string 		:shipping_address_id
      #t.string     :billing_address_id
      #t.string     :shipping_address_id
      t.belongs_to :user, index:true
      t.belongs_to :credit_card, index:true

      t.timestamps null: false
    end
  end
end
