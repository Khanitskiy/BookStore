require 'rails_helper'

RSpec.describe Rating, type: :model do
  
  it { should belong_to :customer }
  it { should belong_to :book }

  it "is invalid when rating 0" do
    expect(FactoryGirl.build :rating, rating: 0).not_to be_valid
  end

  it "is invalid when rating a negative number" do
    expect(FactoryGirl.build :rating, rating: -1).not_to be_valid
  end

   it "is invalid when rating more 10" do
    expect(FactoryGirl.build :rating, rating: 0).not_to be_valid
  end

end
