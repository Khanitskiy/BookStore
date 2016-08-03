class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
    	t.string   :title
      t.string   :text_review
      t.integer  :rating
      t.boolean  :access, default: false
      
      t.belongs_to :book, index:true
      t.belongs_to :user, index:true

      t.timestamps null: false
    end
  end
end
