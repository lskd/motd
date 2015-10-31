class MotdController < ApplicationController

  # Defining a Constant outside the action but inside the class
  # else Rails chums on chud over dynamic assignments to CONSTANTS
  # the action/method is run multipletimes and the object id value changes
  # even though the value definition stays the same..
  # CONSTANTS are in capitals
  APP_NAME = "http-party"

  # ENV Variables expected to be set in rails app directory
  # These are referenced as below
  ##     ENV["NASA_MOTD_API_KEY"]
  ##     ENV["MASHAPE_MOTD_API_KEY"]

  def index
  end

  def page1


    # github requires api calls to include a User-Agent in the header
    # headers tag and the APP_NAME variable define and set this attribute
    @zen = HTTParty.get('https://api.github.com/zen', headers: {"User-Agent" => APP_NAME}) # APP_NAME defined above as constant
    # swap out zen for zen2 to avoid ratelimit in testing
    # @zen2 = "Space vacuums Sun-Stars for the Dark Forest treaty"

    @abstract_image = "http://lorempixel.com/900/200/abstract" # 900 px width
    #@abstract_image = "http://lorempixel.com/750/200/abstract" # almost banner
    #@abstract_image = "http://lorempixel.com/450/300/abstract" # too square

    # # Yoda Talk using mashape api call
    # # This works in irb but not in controller atm. hrm..
    # # Error response references heroku failure though I'm not hitting heroku
    # mashape_motd_api_key = ENV["MASHAPE_MOTD_API_KEY"]
    # @zen_to_yoda = HTTParty.get("https://yoda.p.mashape.com/yoda?sentence=#{@zen2}",
    #   headers:{
    #     "X-Mashape-Key" => mashape_motd_api_key,
    #     "Accept" => "text/plain"
    #   })
    #   @yoda_response = @zen_to_yoda

    ## Calling in the Weathering function so the view can pull data
    weathering()
  end


  def page2
    # spaceimage & weathering method/function/action returns last line of method
    # which is instance variable @spacepix & @weather
    # this instance variable @spacepix & @weather is what the view calls
    # within a inline ruby <%=  %> tag call
    page1
    spaceimage
    weathering(params[:zipcode])
  end



  def spaceimage
    # Define today's date
    @date_now = Date.today.to_s

    # Set api key
    nasa_motd_api = ENV["NASA_MOTD_API_KEY"] # these won't be in view so no @

    # Sets the space url for inlined-interporlation
      space_url = "https://api.data.gov/nasa/planetary/apod?date=#{@date_now}&api_key=#{nasa_motd_api}"
      @spacepix = HTTParty.get(space_url) # ingress data into @spacepix instance

      # remove for production (avoiding rate limit)
      #@spacepix = "http://mars.jpl.nasa.gov/msl-raw-images/msss/01000/mcam/1000ML0044450000405085D01_DXXX.jpg"

    # old API key no longer works : nasa's side?, I reckon true
    # DEMO_KEY : works on mars data examples off api document site

    # Mars Rover API calls
    # Cams of interest navcam, rhaz, fhaz - (Hazard Avoidance Cams)
    # sol = days on mars
    # Lowest Common Dinominator of Sol days is the Curiosity rover (lcd)
    # Max sol & Max days = 1132 & 2015-10-13 respectively for Curiosity
    #
    # Randommize the sol date per call
    # Note : Not all cams are used daily, so this may return fugly nilz
      @sol = rand(12...1120) # random curiosity sol days as lcd
      @mars_cams = %w(navcam mast rhaz fhaz).shuffle.first #pick a cam any cam
      @mars_rover = %w(curiosity spirit opportunity).shuffle.first #pick a rover
      @capital_rover = @mars_rover.capitalize # slip around view limitation atm

      mars_url = "https://api.nasa.gov/mars-photos/api/v1/rovers/#{@mars_rover}/photos?sol=#{@sol}&camera=#{@mars_cams}&api_key=#{nasa_motd_api}" # swap in DEMO_KEY if failing
      @mars_rover_data = HTTParty.get(mars_url) # ingress data
      ## Above :
      ## set @mars_rover_data to nil(@mars_rover_data = {})  for testing defaults
                #render plain: @mars_rover_data # Raw data check

      #Conditional check for nil and define default if found
            # other checks, not used this round
            # a ||= b   .blank?   variable = id if variable.blank?
      if @mars_rover_data["photos"].nil?

        # We have invalid data from @mars_rover_data
        # Set default rover name
        @capital_rover = "Curiosity"
        # Set random default images, shuffled.last # cause first is over-rated atm
        @random_roover_default_img_src = ["http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01105/opgs/edr/fcam/FRB_495583818EDR_F0500000FHAZ00323M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00478/opgs/edr/ncam/NLB_439921111EDR_F0240366NCAM00399M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00786/opgs/edr/fcam/FLB_467267584EDR_F0440036FHAZ00323M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00867/opgs/edr/ncam/NLB_474458330EDR_F0450000NCAM00320M_.JPG", "http://mars.jpl.nasa.gov/msl-raw-images/msss/01000/mcam/1000ML0044450000405085D01_DXXX.jpg", "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01004/opgs/edr/fcam/FRB_486615455EDR_F0481570FHAZ00323M_.JPG"].shuffle.last

        # Set @mars_photo_url to use randomized default image
        @mars_photo_url = @random_roover_default_img_src
        @where_mars_rover_set = "Mars data set from the nil conditional"
        # Single Default defined below is moving towards deprecation
        # @mars_photo_url ="http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01004/opgs/edr/fcam/FRB_486615455EDR_F0481570FHAZ00323M_.JPG"

      else
        # We have valid data :
        # Set the img_src from @mars_rover_data block
        @mars_photo_url = @mars_rover_data["photos"][0]["img_src"]
        @where_mars_rover_set = "Mars data set from the api data call"
      end
  end

  # weathering method returns @weather instance
  # set default values for page1 view to set @current_weather
  # look to page2 action (eof) for params pass of zip to weathering method call
  def weathering(zip = 90254) # sets a default zip for page1(hermosa beach area)
  # render plain: zip  # render out the plan zip value

  # Convert Zipcode to latitude & longitude
    @zip_to_latlong = HTTParty.get("http://api.zippopotam.us/us/#{zip}")
      # Conditional check for nil and define default if found
      # Invalid data would come from a non-valid zipcode submission
      if @zip_to_latlong["places"].nil? #is @zip_to_latlong nil in value?
        # We have invalid data from @zip_to_lat zipcode call
        # Set defaults for latitude(lat) & longitude(lng)
          # Corresponds to default zip 90254
        @lat = "33.8643"
        @lng = "-118.3955"

      else
        # We have valid data :
        # Set the latitude(lat) & longitude(lng) from @zip_to_lat block
        @lat = @zip_to_latlong['places'][0]['latitude']
        @lng = @zip_to_latlong['places'][0]['longitude']
      end

  # Pull the weather data in regards to latitude & longitude specs
    @weather = HTTParty.get("https://api.forecast.io/forecast/b6ec16c6daf2eaa642175d3a5d80d219/#{@lat},#{@lng}")
  end

end
