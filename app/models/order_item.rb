class OrderItem < ActiveRecord::Base
  validates :quantity, presence: true

  belongs_to :book
  belongs_to :order

  scope :by_order_and_book, -> order_id, book_id { 
    where(order_id: order_id, book_id: book_id) }

  class << self

  def create_items(cookies, order_id)
    return unless cookies
    cookies.each { |book| create_item(book, order_id) }
  end

  def update_items(cookies, order_id)
    return unless cookies
    cookies.each do |book|
      @order_item = OrderItem.by_order_and_book(order_id, book.first.to_i).first
      if @order_item
        @order_item.update(quantity: book.second.to_i + @order_item.quantity)
      else
        create_item(book, order_id)
      end
    end
  end

  private

  def create_item(book, order_id)
    OrderItem.create(order_id: order_id,
                     book_id: book.first.to_i,
                     quantity: book.second.to_i)
  end

  end
end
