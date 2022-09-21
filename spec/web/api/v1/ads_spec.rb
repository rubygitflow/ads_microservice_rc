require_relative 'spec_helper'

describe '/api/v1/ads' do
  it "should GET 200" do
    visit '/api/v1/ads'
  end
  
  # it "should POST 200" do
  #   visit '/api/v1/ads'
  # end
end
