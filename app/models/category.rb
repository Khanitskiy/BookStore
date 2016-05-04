class Category < ActiveRecord::Base
	validates :title, presence: true
	validates :title, uniqueness: true

	has_many :books

  def self.all_book_category(id)
    find(id).books
  end

  def self.title_category(id)
  	find(id).title
  end

end
