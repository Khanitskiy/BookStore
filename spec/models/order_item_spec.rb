require 'rails_helper'
  
RSpec.describe OrderItem, type: :model do

  before(:all) do
    @order = FactoryGirl.create :order
  end

  let(:empty_cookies) { 
    {"book_count"=>"0", "total_price"=>"0"}
  }

  let(:cookies) { 
    {"book_count"=>"6", "id_3"=>"2", "id_2"=>"3", "id_1"=>"1"}
  }

  it { should validate_presence_of(:quantity) }
  it { should belong_to (:book) }
  it { should belong_to (:order) }

  context 'creates orders' do

    it "doesn't create order items" do
      OrderItem.create_items(empty_cookies, @order.id)
      expect(OrderItem.all.count).to eq 0
    end

    it "doesn't throw exception and doesn't create order items" do
      empty_cookies = {}
      OrderItem.create_items(empty_cookies, @order.id)
      expect(OrderItem.all.count).to eq 0
    end

    it "creates three order items" do
      OrderItem.create_items(cookies, @order.id)
      expect(OrderItem.all.count).to eq 3
    end

  end

  context 'updates or creates order items' do
    let(:create_order_items) { 
      FactoryGirl.create :order_item, quantity: 3, book_id: 1, order_id: @order.id
      FactoryGirl.create :order_item, quantity: 1, book_id: 2, order_id: @order.id
    }

    let(:count) { 
      count = 0
      (1..3).each do |i|
        item = OrderItem.where(order_id: @order.id, book_id: i).first
        count += item.quantity.to_i unless item.nil?
      end
      count
    }

    it "adds two order items and create one order item" do
      create_order_items
      OrderItem.update_items(cookies, @order.id)
      expect(count).to eq 10
    end

    it "create three order items" do
      OrderItem.update_items(cookies, @order.id)
      expect(count).to eq 6
    end

    it "updates three order items" do
      create_order_items
      FactoryGirl.create :order_item, quantity: 5, book_id: 3, order_id: @order.id
      OrderItem.update_items(cookies, @order.id)
      expect(count).to eq 15
    end

    it "dosn't create order items" do
      OrderItem.update_items(empty_cookies, @order.id)
      expect(count).to eq 0
    end

    it "dosn't update order items" do
      create_order_items
      FactoryGirl.create :order_item, quantity: 5, book_id: 3, order_id: @order.id
      OrderItem.update_items(empty_cookies, @order.id)
      expect(count).to eq 9
    end

  end

end