class MotdController < ApplicationController

  APP_NAME = "motd"
    # set ENV Variables in rails app directory or manage ENV with figaro
    # ENV["NASA_MOTD_API_KEY"]
    # ENV["MASHAPE_MOTD_API_KEY"]
    # ENV["MASHAPE_MOTD_API_KEY"] # TODO

  def index
    # Github api endpoint needs User-Agent sent within the header
    @zen = HTTParty.get('https://api.github.com/zen', headers: {"User-Agent" => APP_NAME})

    # TODO Take github Zen quote and pipe thru yoda api request
    # mashape_motd_api_key = ENV["MASHAPE_MOTD_API_KEY"]
    # @zen_to_yoda = HTTParty.get("https://yoda.p.mashape.com/yoda?sentence=#{@zen}",
    #   headers:{
    #     "X-Mashape-Key" => mashape_motd_api_key,
    #     "Accept" => "text/plain"
    #   })
    #   @yoda_response = @zen_to_yoda

    ## Weathering function using default zipcode for index weather data request
    weathering()
  end

  def weather_rover
    # spaceimage & weathering method/function/action returns last line of method
    # which is instance variable @spacepix & @weather
    index
    spaceimage
    weathering(params[:zipcode]) # uses submitted zipcode
  end

  def spaceimage
    @date_now = Date.today.to_s
    if ENV["NASA_MOTD_API_KEY"].nil?
      nasa_motd_api = "DEMO_KEY"
    else
      nasa_motd_api = ENV["NASA_MOTD_API_KEY"]
    end
    # NASA Astronomy Picture of the Day api request
    space_url = "https://api.nasa.gov/planetary/apod?date=#{@date_now}&api_key=#{nasa_motd_api}"
    @spacepix = HTTParty.get(space_url)

    # Mars Rover API call randomly selects a Rover, Cam, and Sol days
    # Max sol = 1120 active images for Curiosity on 2015-10-13
    @sol = rand(12...1120)
    @mars_cams = %w(navcam mast rhaz fhaz).shuffle.first
    @mars_rover = %w(curiosity spirit opportunity).shuffle.first
    mars_url = "https://api.nasa.gov/mars-photos/api/v1/rovers/#{@mars_rover}/photos?sol=#{@sol}&camera=#{@mars_cams}&api_key=#{nasa_motd_api}"
    @mars_rover_data = HTTParty.get(mars_url)

    # define fallback images for nil response
    if @mars_rover_data["photos"].nil?
      @mars_rover = "Curiosity"
      @mars_photo_url = ["http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01105/opgs/edr/fcam/FRB_495583818EDR_F0500000FHAZ00323M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00478/opgs/edr/ncam/NLB_439921111EDR_F0240366NCAM00399M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00786/opgs/edr/fcam/FLB_467267584EDR_F0440036FHAZ00323M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00867/opgs/edr/ncam/NLB_474458330EDR_F0450000NCAM00320M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/msss/01000/mcam/1000ML0044450000405085D01_DXXX.jpg", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01004/opgs/edr/fcam/FRB_486615455EDR_F0481570FHAZ00323M_.JPG"].shuffle.last
    else
      @mars_photo_url = @mars_rover_data["photos"][0]["img_src"]
    end
  end

  def weathering(zip = 90254) # define latitude & longitude with zipcode
    @zip_to_latlong = HTTParty.get("http://api.zippopotam.us/us/#{zip}")
    if @zip_to_latlong["places"].nil?
      @lat = "33.8643"
      @lng = "-118.3955"
      @area = "Hermosa Beach"
    else
      @lat = @zip_to_latlong['places'][0]['latitude']
      @lng = @zip_to_latlong['places'][0]['longitude']
      @area = @zip_to_latlong['places'][0]['place name']
    end
      # Weather api request using latitude & longitude
    @weather = HTTParty.get("https://api.forecast.io/forecast/b6ec16c6daf2eaa642175d3a5d80d219/#{@lat},#{@lng}")
  end
end
