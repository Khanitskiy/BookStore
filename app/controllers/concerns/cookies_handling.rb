module CookiesHandling
  extend ActiveSupport::Concern
  
  private

  def cookies_nil
    @cookies_count = {'book_count' => '0'} unless @cookies_count
  end

  def cookies_json_parse(name)
     JSON.parse(cookies[name]) if cookies[name]
  end

  def cookies_delete
    cookies.delete :books
    cookies.delete :book_count
    cookies.delete :user_products_count
  end

  def create_cookies_book
    @cookies_book  = JSON.parse(cookies[:books])
    @cookies_count = JSON.parse(cookies[:book_count])
    cookies_nil
  end

end