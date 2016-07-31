class CategoriesController < ApplicationController
  load_and_authorize_resource
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Shop', :books_path

  def show
    @categories = Category.all
    @books = Category.find_by_id(params[:id]).books.page params[:page]
    add_breadcrumb Category.find_by_id(params[:id]).title, category_path(params[:id])
  end
end