class Pixnet::ArticleJob < ActiveJob::Base
  queue_as :default

  def perform(article)
    article.fetch_article_data!
  end
end
