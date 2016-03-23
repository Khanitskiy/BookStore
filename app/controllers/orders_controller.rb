class OrdersController < ApplicationController

	def new
		@cookies_book = JSON.parse(cookies[:books]) if cookies[:books]
		@ids = Array.new
		@cookies_hash = Hash.new
		@cookies_book.try(:each) do |book| 
			@cookies_hash[book[0][3..-1]] = book[1]  unless book[0] == "book_count"
			@ids << book[0][3..-1] unless book[0] == "book_count"
		end
		@books = Book.where(:id => @ids)
		@subtotal = 0
		#byebug
	end

	def clear_shopcart
		cookies.delete :books
		redirect_to books_path 
	end

	def update
		
	end

	def show

	end

	def index

	end

	def destroy
		
	end

	def add_to_order

	end

end
