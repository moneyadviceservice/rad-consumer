if Rails.env.production?
  require 'redis'

  Geocoder.configure(
    lookup: :google,
    use_https: true,
    api_key: ENV['GOOGLE_GEOCODER_API_KEY'],
    cache: Redis.new(url: ENV['REDISTOGO_URL'])
  )
end

if Rails.env.development?
  Geocoder.configure(
    lookup: :google,
    use_https: false,
    api_key: ENV['GOOGLE_GEOCODER_API_KEY']
  )
end
