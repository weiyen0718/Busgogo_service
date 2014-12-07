#require 'bundler/setup'
require 'sinatra/base'
require 'busgogo'
require 'json'
# require './tutorial'


require 'bundler/setup'
require 'haml'
require 'sinatra/flash'

class Bus < Sinatra::Base
	enable :sessions
	register Sinatra::Flash

		configure :production, :development do
		enable :logging
		end

	helpers do
		def user
			num = params[:num].to_i
			# @station = user
			return nil unless num

			profile_after={
		 		'station' => num,
				'profiles' => 'not yet found'
			}

			begin
				# WebScraper::Scraper.busstation.each do |value|
				# 		profile_after['profiles'].push('station' => value)
				# end
				# profile_after

				buses = WebScraper.new
				stations = buses.busstation
				profile_after['profiles'] = stations[num]
			rescue
				return nil
			end
			profile_after
		end

	end

	# 	def get_profile(station)
	#        	scmachine = WebScraper.new


	# 			profile_after={
	# 			'station' => station,
	# 			'profiles' => []
	# 			}

	# 			scmachine.busstation.each do |value|
	# 			profile_after['profiles'].push('station' => value)

	# 			end
	# 			profile_after

	# 	end
	# end


	get '/' do
		 'Busgogo service is working at homepage'
	end

	get '/station' do
		'Busgogo service is working at station homepage'
	end

	get '/station/*?' do
		'Busgogo service is working at station page'
	end


	post '/api/v1/tutorials' do
		content_type :json
			begin
				req = JSON.parse(request.body.read)
				logger.info req
			rescue
			halt 400
		#endTables: 0

			tutorial = Tutorial.new
			tutorial.num = req['num'].to_json
			tutorial.station = req['station'].to_json
			if tutorial.save
				status 201
				redirect "/api/v1/tutorials/#{tutorial.id}"
			end
	end



	get '/api/v1/tutorials/:id' do
	 	content_type :json, 'charset' => 'utf-8'

	  begin
		  @tutorial = Tutorial.find(params[:id])
			num = @tutorial.num
			station = @tutorial.station
			result = { num: num, station: station }.to_json
			logger.info("Found: #{result}")
			result
		rescue
			halt 400
		end
	end

end
end
