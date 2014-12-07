require 'minitest/autorun'
require 'minitest/rg'
require './lib/busgogo.rb'

teststation = {
  '1' => '新竹地區',
  '2' => '竹東地區',
  '3' => '關西地區',
  '4' => '桃園地區',
  '5' => '苗栗地區',
  '6' => '國道班車資訊',
  '7' => '一般公路資訊',
  '8' => '新竹市區公車',
  '9' => '桃園縣市區公車資訊',
  '10' => '免費公車資訊'
}

describe 'station' do

  before do
    mac = WebScraper.new
    @found = mac.busstation
  end

  it 'find 新竹地區' do
    @found[8].wont_match "\d"
  end
  it 'find 新竹地區' do
    @found[8].wont_be_empty
  end
  it 'find 苗栗地區' do
    @found[9].wont_be_empty
  end
  it 'find 新竹地區' do
    @found[1].must_equal teststation['1']
  end

  it 'find 苗栗地區' do
    @found[5].must_equal teststation['5']
  end

  it 'find 桃園縣市區公車資訊' do
    @found[9].must_equal teststation['9']
  end
end
