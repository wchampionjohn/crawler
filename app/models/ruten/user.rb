class Ruten::User < ApplicationRecord
  include Ruten

  validates_presence_of :account, uniqueness: true
  validate :exists_in_ruten # 帳號必須是露天的賣家才可以成功儲存

  def fetch_products
  end

  def fetch_base_info
    # 賣場首頁同步商品數
    self.class.fetch_page(self.index_url) do |html|
      self.office_products_count = html.css('select.store-search-select option[@value="0"]')
                                      .text.gsub(/[^\d]/, '')
                                      .to_i
    end

    # 關於我頁面同步關於我
    self.class.fetch_page(self.about_url) do |html|
      self.about = html.css('.seller-info').to_html
    end

    # 賣家評價頁面同步評價資訊
    self.class.fetch_page(self.credit_url) do |html|
      points = html.css('table#table63 tr')[3..-1].map { |tr| tr.css('td').last.text.strip }
      points.delete_if { |point| point == "" }
      self.good_point  =  points[0] # 好的評價
      self.soso_point  =  points[3] # 普通的評價
      self.bad_point   =  points[5] # 不好的評價
    end

    self
  end

  def total_point
    if self.good_point.present? || self.bad_point.present? || self.soso_point.present?
      self.good_point.to_i + self.bad_point.to_i + self.soso_point.to_i
    end
  end

  def point_percent
    if self.total_point.present?
      (self.good_point.to_f / self.total_point.to_f).round(4) * 100 # 算出百分比
    end
  end

  def index_url
    "#{Settings.Ruten.host}/user/index00.php?s=#{account}"
  end

  def about_url
    "#{Settings.Ruten.host}/user/about.php?s=#{account}"
  end

  def credit_url
    "https://mybid.ruten.com.tw/credit/point?#{account}"
  end

  private
  def exists_in_ruten
    unless exist_in_ruten?
      errors.add(:account, "必須是露天拍賣已存在的賣家")
    end
  end

  def exist_in_ruten?
    begin
      self.class.fetch_page(self.index_url)
      true
    rescue Net::HTTPServerException => e
      false
    end
  end
end
