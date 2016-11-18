class Pixnet::User < ApplicationRecord
  validates_presence_of :account

  def full_name
    hint = name.blank? ? '' : " (#{name})"
    "#{self.account}#{hint}"
  end
end
