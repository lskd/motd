

## MOTD : Muse of the Day

* aka  _Message_ _of_ _the_ _Day_

___
The *MOTD* app uses api endpoints to provide dynamic info.

[Weather](https://api.forecast.io) info is based on [zipcode](http://api.zippopotam.us) translation to Latitude & Longitude

Zen quote from Github's [Zen](https://api.github.com/zen) of the day api endpoint

Abstract image from [lorempixel's](lorempixel.com) api endpoint

Nasa's [Astronomy picture of the day](http://apod.nasa.gov/apod/astropix.html) api [endpoint](https://api.nasa.gov/api.html#apod)

Nasa's [Rover images](https://api.nasa.gov/api.html#MarsPhotos) is randomly selected with Rover, Camera and Sol days variables
* camera based on 4 cameras(navcam, mast, rhaz, fhaz) consistent across the 3 rovers  (Curiosity, Spirit, and Opportunity)
* Sol days on the youngest active rover, Curiosity @ 1120 sol days at time of writing.
* nil responses fallback to a randomly selected image

___

### Install

```
git clone https://github.com/lskd/motd.git ./motd
cd motd
rake bundle
rails s
within a firefox or chrome browser, goto localhost:3000
```

* DEMO_KEY is used in MotdController for demo purposes. For extendted use, get your own api key from [NASA](https://api.nasa.gov/#getting-started)
* Set your [NASA](https://api.nasa.gov/#getting-started) api key with ENV['NASA_MOTD_API_KEY'] in MotdController
* rails server -e production requires ENV SECRET_KEY_BASE to be set

___
_TODO_ : push github's Zen of the day thru Yoda api
