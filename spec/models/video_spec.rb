require 'spec_helper'

describe Video do
  it "should save the video content" do
    video = Video.new(title: "A comdedy", description: "Some content here")
    video.save
    expect(Video.first).to eq video
  end

  it "belongs to one category" do
    category = Category.create(name: "Comedy")
    video = Video.create(title: "A comdedy", description: "Some content here", category: category)
    expect(video.category).to eq category
  end
end
