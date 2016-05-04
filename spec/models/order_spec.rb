require 'rails_helper'

RSpec.describe Order, type: :model do

  before(:all) do
    @user = FactoryGirl.create :user
  end

  let(:create_orders) { 
    FactoryGirl.create_list :order, 2, state: 'in_delivery', user_id: @user.id
    FactoryGirl.create_list :order, 3, state: 'delivered', user_id: @user.id
    FactoryGirl.create_list :order, 2, state: 'in_queue', user_id: @user.id
    @last_order_queue = FactoryGirl.create :order, state: 'in_queue', user_id: @user.id
  }
  
  it { should validate_presence_of(:total_price) }
  it { should validate_presence_of(:state) }
  it { should have_many (:order_items) }
  it { should belong_to (:user) }
  it { should belong_to (:credit_card) }
  it { should have_one (:billing_address) }
  it { should have_one (:shipping_address) }
  it { should have_one (:cupon) }

  it "should set completed date when validated" do
    order = FactoryGirl.create :order
    order.valid?
    expect(order.completed_date).to eq 3.days.from_now.strftime("%a, %d %b %Y").to_date
  end

  it "By default an order should have 'in progress' state" do
  	order = FactoryGirl.create :order
  	expect(order.state).to eq('in_progress')
  end

  it "should than method create_order creating order record" do
    order = Order.create_order('0', 0, @user.id)
    expect(@user.orders.first.id).to eq(order)
  end

  it "returns last order which state = in_queue" do
    create_orders
    expect(Order.last_order_queue(@user)).to eq @last_order_queue
  end

  it "return all order which state = in_queue" do
    create_orders
    expect(Order.in_queue(@user).count).to eq(3)
  end

  it "return all order which state = in_delivery" do
    create_orders
    expect(Order.in_delivery(@user).count).to eq(2)
  end

  it "return all order which state = delivered" do
    create_orders
    expect(Order.delivered(@user).count).to eq(3)
  end

end