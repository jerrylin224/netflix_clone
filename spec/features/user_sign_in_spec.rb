require 'spec_helper'

feature 'user signs in' do 
  scenario 'with valid email and password' do 
    charlie = Fabricate(:user)
    sign_in(charlie)
    expect(page) have_content charlie.full_name
  end
end
