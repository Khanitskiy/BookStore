require 'rails_helper'

RSpec.describe Order, type: :model do
  
  it { should validate_presence_of(:total_price) }
  it { should validate_presence_of(:completed_date) }
  #it { should validate_presence_of(:state) }
  it { should have_many (:order_items) }
  it { should belong_to (:customer) }
  it { should belong_to (:credit_card) }

  it "By default an order should have 'in progress' state" do
  	order = FactoryGirl.create(:order, total_price: 255.22, completed_date: Time.now)
  	expect(order.state).to eq(1)
  end

end