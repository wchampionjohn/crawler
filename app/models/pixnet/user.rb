class Pixnet::User < ApplicationRecord
  include Pixnet
  validates_presence_of :account
  serialize :hits

  def full_name
    hint = name.blank? ? '' : " (#{name})"
    "#{account}#{hint}"
  end

  def sync
    json_object = JSON.parse(open(sync_url).read)
    self.attributes=json_object["blog"].slice(*self.class.column_names)
  end

  private
  def sync_url
    "https://emma.pixnet.cc/blog?format=json&user=#{self.account}"
  end
end
