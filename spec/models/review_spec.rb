require 'spec_helper.rb'

describe Review do
  it { should validate_presence_of :rating }
  it { should validate_presence_of :content }
end