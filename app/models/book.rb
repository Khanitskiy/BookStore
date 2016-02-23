class Book < ActiveRecord::Base
	validates :title, :price, :in_stock, presence: true
	validates :price, numericality: { greater_than: 0 }
	validates :in_stock, numericality: { only_integer: true, greater_than: 0 }


	belongs_to :author
	belongs_to :category
	
	has_many   :ratings
  has_many   :customers, through: :ratings
  #has_many   :order_items

end
