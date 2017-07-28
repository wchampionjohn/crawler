class Ruten::Product < ApplicationRecord
  include Ruten

  belongs_to :user, :counter_cache => true

  validates :origin_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :user, presence: true

  before_validation :fetch_remote_data, on: :create

  mount_uploader :main_img, ::RutenProductImageUploader

  def detail_url
    "http://goods.ruten.com.tw/item/show?#{self.origin_id}"
  end

  def fetch_remote_data!
    fetch_remote_data
    save!
  end

  def fetch_remote_data
    return nil if self.origin_id.blank?
    html = self.class.fetch_page detail_url

    self.title = html.css('div .main-content h1').first.text
    self.price = html.css('strong.price').text.delete(',')
    self.sale_out_num = html.css('table.item-detail-table tr td')[1].text.strip
    self.pay_way = html.css('table.item-detail-table tr td')[3].text.strip.gsub(/\n/,'').split.join(' / ')
    self.transport_way = html.css('table.item-detail-table tr td')[5].text.strip.split("\n").first
    self.situation = html.css('ul#product-memo li')[0].text.split('：').last.delete(' ')
    self.location = html.css('ul#product-memo li')[1].text.split('：').last.delete(' ')
    self.launched_date = html.css('ul#product-memo li')[2].text.split('：').last.gsub(/^ /,'')
    self.remote_main_img_url = html.css('div.item-gallery-main-image img').first['src'].gsub('_m.', '.')
  end

end
