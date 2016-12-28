module Pixnet::UsersHelper
  def pixnet_blog_link(user)
    "http://#{user.account}.pixnet.net"
  end

  def formated_hits(hits)
    content = if hits.blank?
                '未同步'
              else
                "#{number_with_delimiter(hits['total'])}(總) #{number_with_delimiter(hits['weekly'])}(週) #{ number_with_delimiter(hits['daily'])}(日)"
              end
    content_tag :p, content, class: 'help-block'
  end

  def full_name(user)
    hint = user.name.blank? ? '' : " (#{user.name})"
    "#{user.account}#{hint}"
  end
end
