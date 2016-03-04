class SearchesController < ApplicationController
	  def search
	    @books = Group.search_book(params[:query])
	  end
end
