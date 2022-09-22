# frozen_string_literal: true
require_relative '../../../spec_helper'
require './app'

describe '/api/v1/ads' do
  it "should GET 200" do
    get '/api/v1/ads'
    assert last_response.ok?
  end
  
  it "should POST 200" do
    post '/api/v1/ads'
    assert last_response.ok?
  end
end
