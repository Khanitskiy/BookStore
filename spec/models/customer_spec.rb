require 'rails_helper'

RSpec.describe Customer, type: :model do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
	it { should validate_uniqueness_of(:email) }
	it { should have_many(:ratings) }
  it { should have_many(:orders) }
  it { should have_many(:books).through(:ratings) }
  
end
