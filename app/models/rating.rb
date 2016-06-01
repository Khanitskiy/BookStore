class Rating < ActiveRecord::Base
  include ActiveModel::Validations
  validates :title, :text_review, :user_id, :rating, :book_id, presence: true, allow_blank: false
  validates_with RatingScore

  belongs_to :book
  belongs_to :user

  # def self.create_rating(params)
  # Rating.create(params).valid?
  # end

  # def self.get_ratings(book_id)
  # where("book_id = book_id")
  # end
end
