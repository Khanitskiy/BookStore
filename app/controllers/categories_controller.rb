class CategoriesController < ApplicationController
  authorize_resource
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Shop', :books_path

  def show
    category = Category.find_by_id(params[:id])
    @categories = Category.all
    @books = category.books.page params[:page]
    add_breadcrumb category.title, category
  end
end