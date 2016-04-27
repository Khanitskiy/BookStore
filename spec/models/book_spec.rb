require 'rails_helper'

RSpec.describe Book, type: :model do
	#let(:my_book) { FactoryGirl.create :book }

  #pending "add some examples to (or delete) #{__FILE__}"

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:in_stock) }
  it { should validate_numericality_of(:price) }
  it { should validate_numericality_of(:in_stock) }
  it { should belong_to (:author) }
  it { should belong_to (:category) }
  it { should have_many(:ratings) }
  it { should have_many(:users).through(:ratings) }

  it "is invalid when price 0" do
    expect(FactoryGirl.build :book, price: 0).not_to be_valid
  end

  it "is invalid when price less 0" do
    expect(FactoryGirl.build :book, price: -1).not_to be_valid
  end

  it "is invalid when in_stock 0" do
    expect(FactoryGirl.build :book, in_stock: 0).not_to be_valid
  end

  it "is invalid when in_stock less 0" do
    expect(FactoryGirl.build :book, in_stock: -1).not_to be_valid
  end

  it "is invalid if in_stock ont integer" do
    expect(FactoryGirl.build :book, in_stock: 22.2).not_to be_valid
  end

   it "persisted?" do
    record = FactoryGirl.create :book
    expect(record.persisted?).to eq true
  end

end