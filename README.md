

## MOTD : Muse of the Day

* aka  _Message_ _of_ _the_ _Day_

___
*MOTD*   app uses api endpoints to provide dynamic info.

Weather info based on zipcode translation to Latitude & Longitude

Github's Zen of the day api

Random Abstract image api request

Nasa's Image of the day

Nasa's Rover images
* randomly selects camera based on 4 cameras(navcam, mast, rhaz, fhaz) consistent across the 3 rovers  (Curiosity, Spirit, and Opportunity)
* randomly selected Sol days on the yougest active rover, Curiosity @ 1120 sol days.
* randomly selects from a collection static images on days no rover images are present

___

### Install

```
git clone https://github.com/lskd/motd.git ./motd
cd motd
rake bundle
rails s
```

* DEMO_KEY is used in MotdController for demo purposes. For extendted use, get your own api key from [NASA](https://api.nasa.gov/#getting-started)
* Set your [NASA](https://api.nasa.gov/#getting-started) api key with ENV['NASA_MOTD_API_KEY'] in MotdController
* rails server -e production requires ENV SECRET_KEY_BASE to be set

___
_TODO_ : push github's Zen of the day thru Yoda api
