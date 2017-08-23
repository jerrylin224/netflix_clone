require 'spec_helper.rb'

feature 'User resets password' do
  scenario 'user succeffully resets the password' do
    charlie = Fabricate(:user, password: 'old_password')
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: charlie.email
    click_button "Send Email"

    open_email(charlie.email)
    current_email.click_link("Reset My Password")
    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: charlie.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    expect(page).to have_content "Welcome, #{charlie.full_name}"
  end
end