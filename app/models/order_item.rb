class OrderItem < ActiveRecord::Base
  validates :quantity, presence: true

  belongs_to :book
  belongs_to :order

  def self.create_items(cookies, order_id)
    cookies.try(:each) do |book|
      create_item(book, order_id)
    end
  end

  def self.update_items(cookies, order_id)
    cookies.try(:each) do |book|
      @order_item = OrderItem.where(order_id: order_id, book_id: book.first.to_i).first
      if @order_item.nil?
        create_item(book, order_id)
      else
        @order_item.update(quantity: book.second.to_i + @order_item.quantity)
      end
    end
  end

  private

  def self.create_item(book, order_id)
    OrderItem.create(order_id: order_id,
                     book_id: book.first.to_i,
                     quantity: book.second.to_i)
  end

end
