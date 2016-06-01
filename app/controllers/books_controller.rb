class BooksController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: [:home, :search]

  def home
    @bestsellers = Book.bestsellers
  end

  def index
    @books = @books.page params[:page]
    @categories = Category.all
  end

  def show
    @book = Book.get_book(params[:id])
  end

  def search
    @categories = Category.all
    @books = Book.search_books(params[:value]).all
  end
end
