class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
    	t.decimal  	 :price
    	t.string	 	 :quantity
    	t.belongs_to :book, index:true
      t.belongs_to :order, index:true

      t.timestamps null: false
    end
  end
end
