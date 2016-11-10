require 'open-uri'
require 'json'
module Pixnet
  extend ActiveSupport::Concern

  def self.table_name_prefix
    'pixnet_'
  end

end
