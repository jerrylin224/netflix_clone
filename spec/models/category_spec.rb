require 'spec_helper'

describe Category do
  it { should have_many :videos}

  describe '#recent_videos' do
    it "returns the videos in the reverse chronical order by created_at" do
      category = Category.create(name: 'Comedy')
      the_hangover = category.videos.create(title: 'The Hangover', description: 'Some contents')
      captain_america = category.videos.create(title: 'The Captain America', description: 'Some contents', created_at: 1.day.ago)
      expect(category.recent_videos).to eq [the_hangover, captain_america]
    end

    it "returns the all the videos if there are less than 6 vidoes" do
      category = Category.create(name: 'Comedy')
      the_hangover = category.videos.create(title: 'The Hangover', description: 'Some contents')
      captain_america = category.videos.create(title: 'The Captain America', description: 'Some contents')
      expect(category.recent_videos.count).to eq 2
    end

    it "returns the 6 the videos if there are more than 6 vidoes" do
      category = Category.create(name: 'Comedy')
      7.times do |i| 
        category.videos.create(title: 'video_#{i}', description: 'Some contents')
      end
      expect(category.recent_videos.count).to eq 6
    end

    it "returns the most recent 6 videos" do 
      category = Category.create(name: 'Comedy')
      6.times do |i| 
        category.videos.create(title: 'video_#{i}', description: 'Some contents')
      end
      should_not_include = category.videos.create(title: 'should not be included', description: 'some contents', created_at: 1.day.ago)
      expect(category.recent_videos).not_to include should_not_include
    end
    it "returns the an empty array if there is no video" do
      category = Category.create(name: 'Comedy')
      expect(category.recent_videos).to eq []
    end
  end
end
