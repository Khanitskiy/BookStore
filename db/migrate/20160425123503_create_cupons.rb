class CreateCupons < ActiveRecord::Migration
  def change
    create_table :cupons do |t|
      t.string  :value
      t.boolean :use, default: false
      t.integer :discount, default: 5
      t.integer :order_id, index: true
      t.timestamps null: false
    end
  end
end
