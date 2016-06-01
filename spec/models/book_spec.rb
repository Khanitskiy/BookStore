require 'rails_helper'

RSpec.describe Book, type: :model do
	let(:create_books) { 
    FactoryGirl.create :book
    FactoryGirl.create_list :book, 2, best_seller: true
  }
  
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
    expect(FactoryGirl.build :book, in_stock: 22.20).not_to be_valid
  end

  it "returns all bestsellers" do
    create_books
    expect(Book.bestsellers.count).to eq(5)
  end

  it "returns book that match transmitted id" do
    create_books
    book = FactoryGirl.create :book
    expect(Book.get_book book.id).to eq(book)
  end

end