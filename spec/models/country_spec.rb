require 'rails_helper'

RSpec.describe Country, type: :model do

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }


  #it "persisted?" do
  #  record = FactoryGirl.create :country
  #  expect(record.persisted?).to eq true
  #end

end
