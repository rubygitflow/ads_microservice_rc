# frozen_string_literal: true
require_relative '../../../spec_helper'
require './app'

describe 'valid route /api/v1/ads' do
  describe 'should have' do
    before do
      options = {
        title: 'Ad title',
        description: 'Ad description',
        city: 'City',
        user_id: 1,
        created_at: Time.now, 
        updated_at: Time.now
      }
     @ad = Ad.create(options)
    end

    it "GET status 200" do
      get '/api/v1/ads'

      assert last_response.ok?
      assert_equal last_response.status, 200
    end

    it "body with ads" do
      get '/api/v1/ads'
      last_ad = JSON.parse(last_response.body).to_h.fetch('data', {})

      assert_equal last_ad.count, Ad.count
      assert (last_ad.first.fetch('user_id', -1) == @ad.user_id)
      assert (last_ad.first.fetch('title', '') == @ad.title)
      assert (last_ad.first.fetch('description', '') == @ad.description)
      assert (last_ad.first.fetch('city', '') == @ad.city)
    end
  end 

  describe 'invalid parameters' do
    ad_params = 
      {
        title: 'Ad title',
        description: 'Ad description',
        city: '',
        user_id: 2
      }
    error_response = 
        {
          'errors' => [
            {
              'detail' => 'is not present',
              'source' => {
                'pointer' => '/data/attributes/city'
              }
            }
          ]
        }

    it 'returns an error' do
      post '/api/v1/ads', params: { ad: ad_params }

      assert_equal last_response.status, 422
      assert_equal JSON.parse(last_response.body), error_response
    end
  end

  describe 'unavailable parameter' do
    ad_params = 
      {
        title: 'Ad title',
        description: 'Ad description',
        city: ''
      }
    error_response = 
        {
          'errors' => [
            {
              'detail' => "Ads::CreateService::Ad: option 'user_id' is required",
              'source' => {
                'meta' => 'В запросе отсутствуют необходимые параметры'
              }
            }
          ]
        }

    it 'returns an error' do
      post '/api/v1/ads', params: { ad: ad_params }

      assert_equal JSON.parse(last_response.body), error_response
      assert_equal last_response.status, 422
    end
  end

  describe 'valid parameters' do
    ad_params = 
      {
        title: 'Ad title',
        description: 'Ad description',
        city: 'City',
        user_id: 2
      }
    count_ads = Ad.count
    
    it "POST status 201" do
      post '/api/v1/ads', params: { ad: ad_params }

      assert_equal last_response.status, 201
    end

    it 'creates a new ad' do
      post '/api/v1/ads', params: { ad: ad_params }

      assert (Ad.count == count_ads.next)
    end

    it 'returns an ad' do
      post '/api/v1/ads', params: { ad: ad_params }

      last_ad = JSON.parse(last_response.body).to_h.fetch('data', {})

      assert (Ad.count > 0)
      assert (last_ad.fetch('id', -1) == Ad.last.id)
    end
  end
end

describe 'invalid route /api/v1' do
  it "should GET 404" do
    get '/api/v1'

    assert_equal last_response.status, 404
  end
end
