class Search < ActiveRecord::Base
	include PgSearch
	pg_search_scope :search_book, :book => [:title]
end
