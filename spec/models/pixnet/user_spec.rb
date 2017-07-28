require 'rails_helper'
require 'vcr_helper'

RSpec.describe Pixnet::User, type: :model do
  let(:user) do
    create(:pixnet_user, :test)
  end

  let(:user_response) do
    VCR.use_cassette 'pixnet user' do
      Net::HTTP.get_response(URI(user.base_info_url))
    end
  end

  let(:user_response_hash) do
    JSON.parse(user_response.read_body)
  end

  let(:user_info) do
    user_response_hash['blog']
  end

  let(:articles_response) do
    VCR.use_cassette 'pixnet articles' do
      Net::HTTP.get_response(URI(user.articles_url))
    end
  end

  let(:articles_response_hash) do
    JSON.parse(articles_response.read_body)
  end

  let(:articles_count) do
    JSON.parse(articles_response.read_body)['total']
  end

  let(:articles) do
    JSON.parse(articles_response.read_body)['articles']
  end

  describe 'fetch base info from pixnet API' do
    it 'returns a 200 OK status' do
      expect(user_response.code).to eq('200')
    end
    it 'can parse name' do
      expect(user_info['name'].blank?).to eq false
    end
    it 'can parse description' do
      expect(user_info['description'].blank?).to eq false
    end
    it 'can parse site_category' do
      expect(user_info['site_category'].blank?).to eq false
    end
    it 'can parse hits' do
      expect(user_info['hits'].blank?).to eq false
    end
    it 'can parse hist detail' do
      expect(user_info['hits']).to include('daily', 'total', 'weekly')
    end
  end

  describe 'writes base info from pixnet API response' do
    before(:each) do
      user.update user_info.slice(*Pixnet::User.column_names)
    end
    it 'can writes name' do
      expect(user[:name].blank?).to eq false
    end
    it 'can writes description' do
      expect(user[:description].blank?).to eq false
    end
    it 'can writes hits' do
      expect(user[:hits].blank?).to eq false
    end
    it 'can writes hist detail' do
      expect(user['hits']).to include('daily', 'total', 'weekly')
    end
  end

  describe 'fetch articles from pixnet API' do
    it 'returns a 200 OK status' do
      expect(articles_response.code).to eq('200')
    end
    it 'can parse articles total count' do
      expect(articles_count).to be_a Integer
    end
    it 'can parse title of each article' do
      articles.each { |article| expect(article['title'].blank?).to eq false }
    end
    it 'can parse origin id of each article' do
      articles.each { |article| expect(article['id'].blank?).to eq false }
    end
  end

  describe '#fetch_articles', type: :job do
    include ActiveJob::TestHelper
    before(:each) do
      allow(Pixnet::User).to receive(:fetch_json_data).and_return(articles_response_hash)
    end
    it 'can update articles count' do
      expect { user.fetch_articles }.to change { user.article_count }.from(nil).to articles_count
    end
    it 'can queues of each fetched article jobs' do
      expect { user.fetch_articles }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by articles_count
    end
  end

  describe '#fetch_base_info' do
    it 'can update base info form Pixnet API' do
      expect(user.name.blank?).to eq true
      expect(user.description.blank?).to eq true
      expect(user.hits.blank?).to eq true

      expect(user).to receive(:fetch_api_and_parse_json).and_return(user_response_hash)
      user.fetch_base_info

      expect(user.name.blank?).to eq false
      expect(user.description.blank?).to eq false
      expect(user.hits.blank?).to eq false
    end
  end
end
