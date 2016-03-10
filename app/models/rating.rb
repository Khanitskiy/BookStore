class Rating < ActiveRecord::Base
	include ActiveModel::Validations
  validates_with RatingScore

	belongs_to :book
	belongs_to :user

	def self.create_rating(params)
    Rating.create(
    	text_review: params[:comment],
      rating:      params[:rating],
      book_id:     params[:book_id],
      user_id:     params[:user_id])
  end

  def self.get_ratings(book_id)
    where("book_id = book_id")
  end


end
