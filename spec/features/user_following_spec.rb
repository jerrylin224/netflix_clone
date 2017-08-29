require 'spec_helper.rb'

feature 'User following' do
  scenario "user follows and unfollows someone" do
    charlie = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: charlie, video: video)

    sign_in
    click_on_video_on_home_page(video)
    click_link charlie.full_name
    click_link "Follow"
    expect(page).to have_content charlie.full_name

    unfollow(charlie)
    expect(page).not_to have_content charlie.full_name
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end