require 'rails_helper'

RSpec.describe Category, type: :model do
  
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should have_many(:books) }

  def self.title_category(id)
  	find(id).title
  end

  it "return title category that match transmitted id" do
  	 category = FactoryGirl.create :category
  	 expect(Category.title_category category.id).to eq(category.title)
  end

  it "return all books this category that match transmitted id category" do
    category = FactoryGirl.create(:category) do |category|
	  (1..3).each do |i| category.books.create(FactoryGirl.attributes_for(:book)) end
	end
	all_book_category = Category.all_book_category category.id
    expect(all_book_category.count).to eq(3)
  end

end