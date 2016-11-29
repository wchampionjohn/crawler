require 'open-uri'
require 'json'
module Pixnet
  extend ActiveSupport::Concern

  def self.table_name_prefix
    'pixnet_'
  end

  module ClassMethods
    def fetch_json_data(url)
      begin
        JSON.parse(open(url).read)
      rescue OpenURI::HTTPError => error
        # Pixnet API Error Codes: http://pixnet.gitbooks.io/api-error-codes/content/
        message = error.io.status.join(' ') + ": " + JSON.parse(error.io.string)['message']
        #ErrorLog.save_record(self, url, message)
      end
    end
  end

end
