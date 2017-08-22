require 'spec_helper.rb'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do

    fictions = Fabricate(:category)
    captain_america = Fabricate(:video, title: "Captain America", category: fictions)
    matrix = Fabricate(:video, title: "The Matrix", category: fictions)
    starship = Fabricate(:video, title: "Starship Troopers", category: fictions)

    sign_in

    add_video_to_queue(captain_america)
    expect_video_to_be_in_queue(captain_america)

    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(matrix)
    add_video_to_queue(starship)

    set_video_position(captain_america, 3) 
    set_video_position(matrix, 1)
    set_video_position(starship, 2)

    update_queue
    
    expect_video_position(captain_america, 3)
    expect_video_position(matrix, 1)
    expect_video_position(starship, 2)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content(link_text)
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video)
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq position.to_s
  end
end
# within(:xpath, "//tr[contains(.,'#{captain_america.title}')]") do
    #   fill_in "queue_items[][position]", with: 3
    # end

    # within(:xpath, "//tr[contains(.,'#{matrix.title}')]") do
    #   fill_in "queue_items[][position]", with: 1
    # end

    # within(:xpath, "//tr[contains(.,'#{starship.title}')]") do
    #   fill_in "queue_items[][position]", with: 2
    # end

    # find("input[data-video-id='#{captain_america.id}']").set(3)
    # find("input[data-video-id='#{matrix.id}']").set(1)
    # find("input[data-video-id='#{starship.id}']").set(2)

# expect(find("input[data-video-id='#{captain_america.id}']").value).to eq "3"
    # expect(find("input[data-video-id='#{matrix.id}']").value).to eq "1"
    # expect(find("input[data-video-id='#{starship.id}']").value).to eq "2"

    # expect(find(:xpath, "//tr[contains(.,'#{captain_america.title}')]//input[@type='text']").value).to eq "3"
    # expect(find(:xpath, "//tr[contains(.,'#{matrix.title}')]//input[@type='text']").value).to eq "1"
    # expect(find(:xpath, "//tr[contains(.,'#{starship.title}')]//input[@type='text']").value).to eq "2"