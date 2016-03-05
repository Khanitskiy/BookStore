class Book < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_books, against: [:title]

	validates :title, :price, :in_stock, presence: true
	validates :price, numericality: { greater_than: 0 }
	validates :in_stock, numericality: { only_integer: true, greater_than: 0 }


	belongs_to :author
	belongs_to :category
	
	has_many   :ratings
  has_many   :users, through: :ratings
  #has_many   :order_items

  mount_uploader :image, BookImgUploader

  def self.bestsellers
    where("best_seller = 'true'")
  end

  def self.get_book(id)
    find(id)
  end

end
