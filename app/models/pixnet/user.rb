class Pixnet::User < ApplicationRecord
  include Pixnet
  validates_presence_of :account
  serialize :hits

  has_many :articles, dependent: :destroy

  before_save :fetch_base_info

  PER_PAGE = 100

	def fetch_articles_later
		Pixnet::GetUserArticlesJob.perform_later(self.id)
	end

  def fetch_articles
    json_object = self.class.fetch_json_data(self.articles_url)
    return nil unless json_object.is_a?(Hash)
    self.update article_count: json_object['total'].to_i
    json_object['articles'].each do |node|
      origin_id = node['id']
      unless self.articles.find_by(origin_id: origin_id)
        ::Pixnet::GetArticleDataJob.perform_later(self.id, origin_id)
      end
    end
		#article_count 為遠端的
    return self.articles.count if current_page * PER_PAGE >= self.article_count
    @current_page += 1
    fetch_articles #遞迴抓下一頁
  end

  def full_name
    hint = name.blank? ? '' : " (#{name})"
    "#{account}#{hint}"
  end

  private
  def base_info_url
    "https://emma.pixnet.cc/blog?format=json&user=#{self.account}"
  end

  def articles_url(page = current_page)
    "https://emma.pixnet.cc/blog/articles?user=#{self.account}&format=json&trim_user=1&status=2&page=#{page}&per_page=#{PER_PAGE}&client_id=#{Settings.Pixnet.consumer_key}"
  end

  def fetch_base_info
    json_object = JSON.parse(open(base_info_url).read)
    self.attributes=json_object["blog"].slice(*self.class.column_names)
  end

  def current_page
    @current_page ||= 1
  end

end
