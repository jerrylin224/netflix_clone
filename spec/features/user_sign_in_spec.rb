require 'spec_helper'

feature 'user signs in' do 
  scenario 'with valid email and password' do 
    charlie = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", with: charlie.email
    fill_in "Password", with: charlie.password
    click_button "Sign in"
    expect(page).to have_content charlie.full_name
  end
end
