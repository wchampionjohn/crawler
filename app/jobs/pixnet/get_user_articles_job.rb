class Pixnet::GetUserArticlesJob < ActiveJob::Base
  queue_as :default

	def perform(user_id)
		Pixnet::User.find(user_id).fetch_articles
	end

end
