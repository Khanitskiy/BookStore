  module ValueCalculation
    extend ActiveSupport::Concern
    
    private

    def calc_subtotal(books)
      subtotal = 0
      cookies_book = cookies_json_parse(:books)
      books.try(:each) do |book|
        subtotal += book.price.to_f * cookies_book[book.id.to_s].to_i
      end
      subtotal
    end

    def parse_ids(obj, select, ids = [])
      obj.try(:each) do |book| 
        book = select ? book.book_id : book[0]
        ids << book 
      end
      ids
    end

    def total_price
      get_books(false)
    end

    def total_calc(val = 0)
      total_price + @order.total_price.to_f + val
    end

    def book_count_calc
      @cookies_book['book_count'].to_i + @order.book_count.to_i
    end

end