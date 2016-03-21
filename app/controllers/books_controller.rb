class BooksController < ApplicationController
	load_and_authorize_resource
	skip_authorize_resource :only => [:home, :search ]

  def home
  	@bestsellers = Book.bestsellers
    #cookies[:name2] = {"4858470042":"4855650104","4854650056":"4862500026"}.to_json
    #byebug
    #@count_products = JSON.parse(cookies[:books])["book_count"] if cookies[:books]
    #byebug
  end

  def index
    #@users = User.order(:name).page params[:page]
    @books = @books.page  params[:page]
  	@categories = Category.all
  end

  def show
  	@book = Book.get_book(params[:id])
  end

  def search
    @categories = Category.all
    @books = Book.search_books(params[:value])
  end

end
