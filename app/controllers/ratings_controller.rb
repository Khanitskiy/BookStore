class RatingsController < ApplicationController
  authorize_resource

  def create
    @rating = Rating.create(comments_params)
    if @rating.id
      @last_comment = Rating.last
      @this_user = current_user
      @not_access = true
      render layout: false
    else
      render text: 'It broke!'
    end
  end

  private

  def comments_params
    params.permit(:title, :text_review, :rating, :user_id, :book_id)
  end
end


