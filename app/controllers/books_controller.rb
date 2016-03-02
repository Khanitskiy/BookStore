class BooksController < ApplicationController
  def home
  	#@books = Book.find_each(best_seller: true)
  	@bestsellers = Book.bestsellers
  end

  def shop
  end
end
