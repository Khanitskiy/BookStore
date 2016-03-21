module ApplicationHelper

  def cp(path)
  	"class=active" if current_page?(path)
  end

  def count_products

  	@count_products = JSON.parse(cookies[:books])["book_count"] if cookies[:books]
  	
  	if @count_products && @count_products != "0" 
  		
  		unless @count_products.to_i >= 100
  			@count_products
  		else
  			"99+"
  		end		
  	else
  		"empty"
  	end
  end
  
end