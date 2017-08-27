require 'spec_helper.rb'

feature  "Admin adds new video" do
  scenario "Admin successfully adds a new video" do
    admin = Fabricate(:admin)
    actions = Fabricate(:category, name: "Actions")
    sign_in(admin)    
    visit new_admin_video_path

    fill_in "Title", with: "Captain America"
    select "Actions", from: "Category"
    fill_in "Description", with: "Marvel series"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"

    click_button "Add Video"
    expect(page).to have_content "You have created the video Captain America"

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector "img[src='/uploads/monk_large.jpg']"
    expect(page).to have_selector "a[href='http://www.example.com/my_video.mp4']"
  end
end