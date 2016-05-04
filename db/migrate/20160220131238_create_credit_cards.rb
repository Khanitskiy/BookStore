class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
    	t.string	:number
    	t.string	:cvv
    	t.integer	:expiration_month
    	t.integer	:expiration_year
    	t.string	:firstname
    	t.string	:lastname
    	t.belongs_to :user, index:true

      t.timestamps null: false
    end
  end
end
