require 'spec_helper.rb'

describe Invitation do
  it { should belong_to(:inviter).class_name(:User) }
  it { should validate_presence_of :recipient_email }
  it { should validate_presence_of :recipient_name }
  it { should validate_presence_of :message }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end
end