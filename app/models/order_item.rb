class OrderItem < ActiveRecord::Base
  validates :quantity, presence: true

  belongs_to :book
  belongs_to :order

  def self.create_items(cookies, order_id)
    cookies.try(:each) do |book|
      unless book.first == 'book_count' || book.first == 'total_price'
        OrderItem.create!(order_id: order_id,
                          book_id: book.first[3..-1].to_i,
                          quantity: book.second.to_i)
      end
    end
  end

  def self.update_items(cookies, order_id)
    cookies.try(:each) do |book|
      # byebug
      unless book.first == 'book_count' || book.first == 'total_price'
        @order_item = OrderItem.where(order_id: order_id, book_id: book.first[3..-1].to_i).first
        # byebug
        if @order_item.nil?
          OrderItem.create!(order_id: order_id,
                            book_id: book.first[3..-1].to_i,
                            quantity: book.second.to_i)
        else
          @order_item.update!(quantity: book.second.to_i + @order_item.quantity.to_i)
        end
      end
    end
  end
end
