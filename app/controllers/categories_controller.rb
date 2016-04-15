class CategoriesController < ApplicationController
  load_and_authorize_resource
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Shop", :books_path

  def show
    @categories = Category.all
    @books =  Category.all_book_category(params[:id]).page params[:page]
    add_breadcrumb  Category.title_category(params[:id]), category_path(params[:id])
  end

end
