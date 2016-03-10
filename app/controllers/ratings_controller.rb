class RatingsController < ApplicationController

	def create
		@rating = Rating.create_rating(params)
		if @rating
			@last_comment = Rating.last
			@this_user = User.get_this_user(current_user)
			render :layout => false
		else
			render :text => "It broke!"
		end
	end

end
