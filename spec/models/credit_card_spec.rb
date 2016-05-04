require 'rails_helper'

RSpec.describe CreditCard, type: :model do

  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:cvv) }
  it { should validate_presence_of(:expiration_month) }
  it { should validate_presence_of(:expiration_year) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should validate_length_of(:number).is_equal_to(16) }
  it { should validate_length_of(:cvv).is_equal_to(3) }
  it { should validate_numericality_of(:number) }
  it { should validate_numericality_of(:cvv) }
  it { should belong_to (:user) }
  it { should have_many(:orders) }

end
