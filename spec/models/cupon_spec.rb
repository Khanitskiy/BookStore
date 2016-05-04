require 'rails_helper'

RSpec.describe Cupon, type: :model do

  let(:create_cupons) { 
    FactoryGirl.create :cupon, use: true
    FactoryGirl.create :cupon
  }

  it { should validate_presence_of(:value) }
  it { should validate_length_of(:value).is_equal_to(9) }
  it { should belong_to (:order) }

  it "return cupon that match transmitted value" do
    create_cupons
    cupon = FactoryGirl.create :cupon
    expect(Cupon.cheking cupon.value).to eq(cupon)
  end

end