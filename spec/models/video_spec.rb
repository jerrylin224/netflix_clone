require 'spec_helper'

describe Video do
  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should have_many(:reviews).order(created_at: :desc)}

  describe "search_by_title" do
    it "returns an empty array if no video match" do
      the_hangover = Video.create(title: 'The Hangover', description: "Some contents here")
      captain_america = Video.create(title: 'Captain America: The Winter Soldier', description: "some contents here")
      expect(Video.search_by_title('apple')).to eq []
    end

    it "returns a array of one video for an exact match" do
      the_hangover = Video.create(title: 'The Hangover', description: "Some contents here")
      captain_america = Video.create(title: 'Captain America: The Winter Soldier', description: "some contents here")
      expect(Video.search_by_title('The Hangover')).to eq [the_hangover]
    end

    it "returns a array of one video for a partial match" do
      the_hangover = Video.create(title: 'The Hangover', description: "Some contents here")
      captain_america = Video.create(title: 'Captain America: The Winter Soldier', description: "some contents here")
      expect(Video.search_by_title('Hangover')).to eq [the_hangover]
    end


    it "returns an array of all matches ordered by created_at" do
      the_hangover = Video.create(title: 'The Hangover', description: "Some contents here")
      captain_america = Video.create(title: 'Captain America: The Winter Soldier', description: "some contents here")
      expect(Video.search_by_title('The')).to eq [the_hangover, captain_america]
    end

    it "returns an empty array if given empty string" do
      the_hangover = Video.create(title: 'The Hangover', description: "Some contents here")
      captain_america = Video.create(title: 'Captain America: The Winter Soldier', description: "some contents here")
      expect(Video.search_by_title('')).to eq []
    end
  end
end