#require 'features/features_spec_helper'
require 'rails_helper'

feature "Search" do
  scenario "Visitor registers successfully via register form" do
    #byebug
    visit root_path(:en) #'http://www.localhost:3000/en'
    within '#search' do
      fill_in 'value', with: 'Rspec'
      click_button('Search')
    end
    #expect(page).not_to have_content 'Sign up'
    #puts page.body
    expect(page).to have_content 'Search results'
    expect(page).to have_text('Rspec')
    #expect(page).to have_content 'You registered'
  end
end