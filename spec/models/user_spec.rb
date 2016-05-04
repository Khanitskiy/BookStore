require 'rails_helper'

RSpec.describe User, type: :model do

 let(:user) { FactoryGirl.create :user }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should have_many(:ratings) }
  it { should have_many(:orders) }
  it { should have_many(:books).through(:ratings) }
  it { should have_one (:billing_address) }
  it { should have_one (:shipping_address) }
  
  it "does not allow duplicate emails" do
    expect(FactoryGirl.build :user, email: user.email).not_to be_valid
  end

end
