require 'rails_helper'

RSpec.describe Pixnet::Image, type: :model do

  pending "can writes article images #{__FILE__}"
  #let(:article) do
    #create(:pixnet_article, :test)
  #end

  #let(:article_response) do
    #VCR.use_cassette 'pixnet article' do
      #Net::HTTP.get_response(URI(article.detail_url))
    #end
  #end

  #let(:article_response_hash) do
    #JSON.parse(article_response.read_body)
  #end

  #let(:remote_article) do
    #article_response_hash['article']
  #end

  #let(:remote_image) do
    #remote_article['images'].first
  #end

  #describe 'writes article images from pixnet API response' do
    #it 'can save image files in local' do
      #image = build(:user_with_set_image_url, article: article,
                                              #url: remote_image['url'],
                                              #digest: Digest::MD5.hexdigest(remote_image['url'].to_s)
                   #)

      ## 減少依賴，這邊用假檔案
      #allow(image).to receive(:set_image_url)
      #image.img = Rack::Test::UploadedFile.new(
        #File.join(Rails.root, 'spec', 'fixtures', 'files', 'image1.jpg')
      #)

      #expect(image).to receive(:set_image_url)
      #image.save
      #expect(image.img.file.exists?).to eq true
    #end
  #end
end
