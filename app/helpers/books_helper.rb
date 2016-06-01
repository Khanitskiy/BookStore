module BooksHelper
  def highlighting_results(string)
    regular_expression = Regexp.new(params[:value], Regexp::IGNORECASE)
    string.sub(regular_expression, "<span style='color: yellow'>#{string.match(regular_expression)}</span>").html_safe
  end
end
