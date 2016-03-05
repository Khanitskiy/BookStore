module BooksHelper

	def highlighting_results(string)
  	string.sub(params[:value], "<span style='color: yellow'>#{params[:value]}</span>").html_safe
  end

end
