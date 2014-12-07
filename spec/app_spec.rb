# encoding: utf-8

require_relative 'spec_helper'
require_relative 'support/story_helpers'
require 'json'


encoded_url = URI.encode('/api/v1/station/新竹地區.json')
URI.parse(encoded_url)

describe 'Busgogo Stories' do
  include StoryHelpers

  describe 'Getting the root of the service' do
    it 'Should return ok' do
      get '/'
      last_response.must_be :ok?
      last_response.body.must_match(/ok/)
    end
  end

  describe 'Getting busgogo information' do
    it 'should return news' do
      get encoded_url
      last_response.must_be :ok?
      
    end

    it 'should return 404 for not a specific number' do
      get "/api/v1/#{random_str(20)}.json"
      last_response.must_be :not_found?
    end
  end

   describe 'Checking data for station' do
  before do
  Tutorial.delete_all
  end

  it 'should find missing badges' do
  header = { 'CONTENT_TYPE' => 'application/json' }
  body = {
  num: ['1'],
  station: ['新竹地區']
      }

# Check redirect URL from post request
post '/api/v2/tutorials', body.to_json, header
    last_response.must_be :redirect?
    next_location = last_response.location
    next_location.must_match /api\/v2\/tutorials\/\d+/

    # Check if request parameters are stored in ActiveRecord data store
    tut_id = next_location.scan(/tutorials\/(\d+)/).flatten[0].to_i
    save_tutorial = Tutorial.find(tut_id)
    JSON.parse(save_tutorial[:num]).must_equal body[:num]
    JSON.parse(save_tutorial[:station]).must_include body[:station]

    # Check if redirect works
    follow_redirect!
    last_request.url.must_match /api\/v2\/tutorials\/\d+/
end


it 'should return 404 for unknown users' do
  header = { 'CONTENT_TYPE' => 'application/json' }
  body = {
    num: [random_str(30)],
    station: [random_str(30)]
  }


  post '/api/v2/tutorials', body.to_json, header
    last_response.must_be :redirect?
    follow_redirect!
    last_response.must_be :not_found?
  end


it 'should return 400 for bad JSON formatting' do
  header = { 'CONTENT_TYPE' => 'application/json' }
  body = random_str(50)

  post '/api/v2/tutorials', body, header
    last_response.must_be :bad_request?
  end

end
end