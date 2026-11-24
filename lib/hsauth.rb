require 'net/http'
require 'uri'
require 'json'

class HSAuth
  attr_accessor :name, :ownerid, :secret, :version, :api_url, :session_id, :user_data, :message

  def initialize(name, ownerid, secret, version = "1.0", api_url = "https://auth.hsdevs.pro/api/1.3/")
    @name = name
    @ownerid = ownerid
    @secret = secret
    @version = version
    @api_url = api_url
    @session_id = nil
    @user_data = {}
    @message = ""
  end

  def init
    res = post({ type: "init", name: @name, ownerid: @ownerid, ver: @version })
    if res && res["success"]
      @session_id = res["sessionid"]
      return true
    end
    @message = res ? res["message"] : "Connection failed"
    false
  end

  def login(username, pass)
    init unless @session_id
    res = post({ type: "login", username: username, pass: pass, sessionid: @session_id, name: @name, ownerid: @ownerid })
    if res && res["success"]
      @user_data = res["info"] || {}
      return true
    end
    @message = res ? res["message"] : "Login failed"
    false
  end

  def license(key)
    init unless @session_id
    res = post({ type: "license", key: key, sessionid: @session_id, name: @name, ownerid: @ownerid })
    if res && res["success"]
      @user_data = res["info"] || {}
      return true
    end
    @message = res ? res["message"] : "License verification failed"
    false
  end

  private

  def post(params)
    uri = URI.parse(@api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(params)
    response = http.request(req)
    JSON.parse(response.body)
  rescue => e
    @message = e.message
    nil
  end
end
