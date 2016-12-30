require 'rails_helper'
require "vcr_helper"

RSpec.describe Pixnet::Article, type: :model do
  let(:article) do
    create(:pixnet_article, :test)
  end

  let(:article_response) do
    VCR.use_cassette 'pixnet article' do
      Net::HTTP.get_response(URI(article.detail_url))
    end
  end

  let(:article_response_hash) do
    JSON.parse(article_response.read_body)
  end

  let(:remote_article) do
    article_response_hash['article']
  end

  let(:images) do
    remote_article['images']
  end

  describe 'fetch article from pixnet API' do
    it 'returns a 200 OK status' do
      expect(article_response.code).to eq('200')
    end
    it 'can parse article title' do
      expect(remote_article['title'].blank?).to eq false
    end
    it 'can parse article content' do
      expect(remote_article['body'].blank?).to eq false
    end
    it 'can parse article images' do
      expect(images).to be_a Array
      expect(images.size).to eq 3 # 這篇測試的article應該會抓到3張圖片
    end
  end

  describe 'writes article from pixnet API response' do
    it 'can writes article title' do
      article.update_column(:title, remote_article['title'])
      expect(article.title.blank?).to eq false
    end
    it 'can writes article content' do
      article.update_column(:content, Nokogiri::HTML(remote_article['body'].to_s).css('body').inner_html)
      expect(article['content'].blank?).to eq false
    end
    it 'can writes article images' do
      # 只檢查Pixnet api的images可寫進DB，所以就不用抓圖檔了
      Pixnet::Image.skip_callback(:validation, :after, :set_image_url)
      images.each do |img|
        article.images.create url: img['url'],
                              digest: Digest::MD5.hexdigest(img['url'].to_s)
      end
      expect(article.images.size).to eq 3
    end
  end

  describe '#fetch_article_data' do
    let(:fetch_and_save) do
      allow(Pixnet::Article).to receive(:fetch_json_data).and_return(article_response_hash)
      article.fetch_article_data and article.save!
    end

    it 'can fetch and write article title' do
      expect { fetch_and_save }.to change { article.content.blank? }.from(true).to false
    end

    it 'can fetch and write article content' do
      expect { fetch_and_save }.to change { article.title.blank? }.from(true).to false
    end
    it 'can write pixnet_img tags in content' do
      expect { fetch_and_save }.to change { Nokogiri::HTML(article.content).css('pixnet_img').size }.from(0).to 3
    end
    it 'can fetch and write article images' do
      expect { fetch_and_save }.to change { article.images.size }.from(0).to 3
    end
  end
end
