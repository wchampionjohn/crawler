class Pixnet::GetArticleDataJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, origin_id)
    article = ::Pixnet::Article.create(user_id: user_id, origin_id: origin_id)
  end

end
