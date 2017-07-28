class Ruten::GetProductDataJob < ApplicationJob
  queue_as :default

  def perform(user_id, origin_id)
    article = ::Ruten::Product.create(user_id: user_id, origin_id: origin_id)
  end
end
