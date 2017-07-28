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

  def pixnet_users_breadcrumb user_id
    if user_id.present?
      breadcrumb('Pixnet', link_to('文章管理', (pixnet_articles_path)), current_collection.take.user.name)
    else
      breadcrumb('Pixnet', '使用者管理')
    end
  end

end
