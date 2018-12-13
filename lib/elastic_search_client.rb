class ElasticSearchClient
  attr_reader :index, :server

  def initialize
    @index  = "rad_#{Rails.env}"
    @server = ENV.fetch('BONSAI_URL', 'http://localhost:9200')
  end

  def search(path, json = '')
    log("POST /#{path}\nRequest Body: #{json}")

    http.post(uri_for(path), json)
  end

  def find(path)
    log("GET /#{path}")

    http.get(uri_for(path))
  end

  private

  def http
    @http ||= begin
      HTTPClient.new.tap do |c|
        c.set_auth(server, username, password) if authenticate?
      end
    end
  end

  def log(message)
    Rails.logger.debug("ElasticSearch Request: #{message}")
  end

  def authenticate?
    username && password
  end

  def username
    ENV['BONSAI_USERNAME']
  end

  def password
    ENV['BONSAI_PASSWORD']
  end

  def uri_for(path)
    "#{server}/#{index}/#{path}"
  end
end
