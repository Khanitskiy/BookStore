class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string  :firstname
      t.string  :lastname
    	t.string	:address
    	t.integer	:zipcode
    	t.string	:city
    	t.string	:phone
    	t.string	:country

      t.timestamps null: false
    end
  end
end
