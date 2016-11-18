module Pixnet::UsersHelper
  def pixnet_blog_link(user)
    "http://#{user.name}.pixnet.net"
  end
end
