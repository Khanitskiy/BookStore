class BooksController < ApplicationController
  load_and_authorize_resource except: [:home, :search]

  def home
    @bestsellers = Book.bestsellers
  end

  def index
    @books = @books.page params[:page]
    @categories = Category.all
  end

  def show
  end

  def search
    @categories = Category.all
    @books = Book.search_books(params[:value])
  end
end