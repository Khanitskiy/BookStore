class Book < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_books, against: [:title]

  validates :title, :price, :in_stock, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :in_stock, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :author
  belongs_to :category

  has_many :ratings, dependent: :destroy
  has_many :users, through: :ratings

  scope :get_books, -> (ids) {  where(id: ids) }
  scope :bestsellers, -> {  where("best_seller = 'true'") }

  mount_uploader :image, BookImgUploader
  paginates_per 9
end
