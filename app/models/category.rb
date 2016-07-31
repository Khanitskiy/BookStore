class Category < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true

  has_many :books

  #scope :all_book_category, ->(id) { find_by_id(id).books }
  #scope :title_category, ->(id) { find_by_id(id).title }
  
end
