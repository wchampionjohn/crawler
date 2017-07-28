module RutenHelpers
  def fetch_page(url, char = nil)
    uri = URI(url)
    request = Net::HTTP::Get.new(uri.request_uri, {'User-Agent' => Settings.user_agents.sample})
    http = Net::HTTP.new(uri.host, 80)
    cookie = CGI::Cookie.new(Settings.Ruten.cookie_key, Settings.Ruten.cookie_value)

    request['Cookie'] = cookie.to_s
    http.request(request)
  end
end

RSpec.configure do |c|
  c.include RutenHelpers
end
