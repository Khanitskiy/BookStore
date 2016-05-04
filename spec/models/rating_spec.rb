require 'rails_helper'

RSpec.describe Rating, type: :model do
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:text_review) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:book_id) }
  it { should_not allow_value("", nil).for(:title) }
  it { should_not allow_value("", nil).for(:text_review) }
  it { should_not allow_value("", nil).for(:user_id) }
  it { should_not allow_value("", nil).for(:rating) }
  it { should_not allow_value("", nil).for(:book_id) }
  it { should belong_to :user }
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
