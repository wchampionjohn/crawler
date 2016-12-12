module Pixnet::ArticlesHelper

  def display_article(article)
    body = article.html_nodes#.css('body')
    body.css('pixnet_img').each do |img_node|
      img_node.name = 'img'
      begin
        img_node['src'] = Pixnet::Image.find_by(digest: img_node['src']).img.url
      rescue NoMethodError
        logger.info "沒圖片的 SRC= #{img_node['original_src']}"
      end
    end

    body
  end

  def pixnet_user_link(user)
    if controller_name == 'users'
      user.name
    else
      link_to user.name, pixnet_user_path(user)
    end
  end

  def pixnet_article_link(article)
    "http://#{article.user.account}.pixnet.net/blog/post/#{article.origin_id}"
  end

  def pixnet_blog_link(user)
    "http://#{user.name}.pixnet.net"
  end

end
