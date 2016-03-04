class BooksController < ApplicationController
	load_and_authorize_resource
	skip_authorize_resource :only => :home

  def home
  	@bestsellers = Book.bestsellers
  end

  def index
  	@categories = Category.all
  end

  def show
  	@book = Book.get_book(params[:id])
  end

  def search

  end

end
