class Rating < ActiveRecord::Base
	include ActiveModel::Validations
  validates_with RatingScore

	belongs_to :book
	belongs_to :user
end
