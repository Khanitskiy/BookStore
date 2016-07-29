class Rating < ActiveRecord::Base
  include ActiveModel::Validations
  validates :title, :text_review, :user_id, :rating, :book_id, presence: true, allow_blank: false
  validates_with RatingScore

  belongs_to :book
  belongs_to :user
end
