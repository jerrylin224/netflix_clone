require 'spec_helper'

describe Category do
  it "save itself" do
    category = Category.create(name: "Comedy")
    expect(Category.first).to eq category
  end

  it "has many vidoes" do
    comedy = Category.create(name: "Comedy")
    hang_over = Video.create(title: "Hang Over", description: "Some content here", category: comedy)
    role_models = Video.create(title: "Role Models", description: "Some content here", category: comedy)
    expect(comedy.videos).to include hang_over, role_models
  end
end
