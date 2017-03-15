module Ruten
  extend ActiveSupport::Concern

  def self.table_name_prefix
    'ruten_'
  end

  module ClassMethods
    def fetch_page url
      uri = URI(url)
      request = Net::HTTP::Get.new(uri.request_uri, {'User-Agent' => Settings.user_agents.sample})
      http = Net::HTTP.new(uri.host, 80)
      cookie = CGI::Cookie.new(Settings.Ruten.cookie_key, Settings.Ruten.cookie_value)

      request['Cookie'] = cookie.to_s
      response = http.request(request)
      response.error! if response.code != "200"
      html = Nokogiri::HTML(response.body)
      #rescue Net::HTTPBadRequest => error

      #ErrorLog.save_record(self, url, 'Big5 轉碼失敗')
      #f.close
      #return nil
      yield(html) if block_given?
    end
  end
end
