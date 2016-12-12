class Pixnet::Article < ApplicationRecord
  include Pixnet
  belongs_to :user
  has_many :images, dependent: :destroy
  validates :origin_id, presence: true
  validates :user, presence: true
  before_validation :fetch_article_data, on: :create

  def request_url
    "https://emma.pixnet.cc/blog/articles/#{self.origin_id}?user=#{self.user.account}&format=json&status=2&client_id=#{Settings.Pixnet.consumer_key}"
  end

  def fetch_article_data!
    fetch_article_data
    save!
  end

  def fetch_article_data
    return nil if self.origin_id.blank?

    json_object = self.class.fetch_json_data request_url
    return nil unless json_object.is_a?(Hash)

    self.title = json_object['article']['title'].to_s
    json_object['article']['images'].each do |node|
      url = if node['url'].to_s =~ %r{^http[s]?://.+}
        node['url'].to_s # 單純 http/https 開頭
      else
        "http:#{node['url'].to_s}" # // 開頭
      end
      url_hash = Digest::MD5.hexdigest(node['url'].to_s)
      if self.new_record? #對應舊資料更新時不需要重抓一樣的圖
        self.images.build(url: url, digest: url_hash)
      else
        self.images.find_or_create_by(url: url, digest: url_hash)
      end
    end
    content_nodes = Nokogiri::HTML(json_object['article']['body'].to_s) do |config|
      config.noblanks
    end
    # Replace img tags
    content_nodes.css('img').each do |img_node|
      digest = Digest::MD5.hexdigest(img_node['src'].to_s)
      if self.images.select{|img| img.digest == digest}.try(:size) > 0
        img_node.name = 'pixnet_img'
        img_node['original_src'] = img_node['src']
        img_node['src'] = digest
      else
        puts "找不到圖 #{img_node['src']}"
      end
    end
    # Clear blank P nodes
    content_nodes.css('p').each do |x|
      x.remove if x.children.size == 1 && x.children.first.name == 'text' && x.children.first.text.blank?
    end
    self.content = Rumoji.encode(content_nodes.css('body').inner_html) # 避免emoji存進db會出錯
  end

  def html_nodes
    @html_nodes ||= Nokogiri::HTML(self.content)
  end

end
