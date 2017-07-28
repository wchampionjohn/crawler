require 'rails_helper'
require 'vcr_helper'
require 'support/ruten_helpers'

RSpec.describe Ruten::User, type: :model do
  let(:user) do
    build(:ruten_user, :test)
  end

  let(:index_response) do
    VCR.use_cassette 'ruten user index' do
      fetch_page user.index_url
    end
  end

  let(:about_response) do
    VCR.use_cassette 'ruten user about me' do
      fetch_page(user.about_url, 'big5')
    end
  end

  let(:credit_response) do
    VCR.use_cassette 'ruten user credit' do
      fetch_page user.credit_url
    end
  end

  let(:index_html) do
    Nokogiri::HTML(index_response.body)
  end

  let(:about_html) do
    Nokogiri::HTML(about_response.body)
  end

  let(:credit_html) do
    Nokogiri::HTML(credit_response.body.force_encoding('big5').encode('UTF-8'))
  end

  let(:products_count) do
    index_html.css('select.store-search-select option[@value="0"]')
      .text.gsub(/[^\d]/, '')
      .to_i
  end

  let(:about_content) do
    about_html.css('.seller-info').to_html
  end

  let(:credit_content) do
    points = credit_html.css('table#table63 tr')[3..-1].map { |tr| tr.css('td').last.text.strip }
    points.delete_if { |point| point == "" }
  end


  let(:user_response_hash) do
    JSON.parse(user_response.read_body)
  end

  let(:user_params) do
    {
      office_products_count: products_count,
      about: about_content,
      good_point: credit_content[0],
      soso_point: credit_content[3],
      bad_point: credit_content[5]
    }
  end


  describe 'fetch user info from ruten user pages' do
    it 'returns a 200 OK status from index page' do
      expect(index_response.code).to eq('200')
    end

    it 'returns a 200 OK status from about me page' do
      expect(about_response.code).to eq('200')
    end

    it('returns a 200 OK status from credit page') do
      expect(credit_response.code).to eq('200')
    end

    it("can parse the products count") { expect(products_count).to be > 0 }
    it("can parse the about me context") { expect(about_content.blank?).to be false }
    it("can parse the credit context") {
      expect(credit_content[0].blank?).to be false
      expect(credit_content[3].blank?).to be false
      expect(credit_content[5].blank?).to be false
    }
  end

  describe 'writes base info from ruten web site' do
    before(:each) do
      user.attributes = user_params
    end

    it 'can writes office products count' do
      expect(user.office_products_count.blank?).to eq false
    end
    it 'can writes about' do
      expect(user.about.blank?).to eq false
    end
    it 'can writes good point number' do
      expect(user.good_point.blank?).to eq false
    end
    it 'can writes soso point number' do
      expect(user.soso_point.blank?).to eq false
    end
    it 'can writes bad point number' do
      expect(user.bad_point.blank?).to eq false
    end
  end

  describe '#fetch_base_info' do
    it 'can fetch user info from ruten web site' do

      expect(user.office_products_count.blank?).to eq true
      expect(user.about.blank?).to eq true
      expect(user.good_point.blank?).to eq true
      expect(user.soso_point.blank?).to eq true
      expect(user.bad_point.blank?).to eq true

      allow(Ruten::User).to receive(:fetch_page).with(user.index_url) { user.office_products_count = 10000 }
      allow(Ruten::User).to receive(:fetch_page).with(user.about_url) { user.about = about_content }
      allow(Ruten::User).to receive(:fetch_page).with(user.credit_url, 'big5') do
        user.good_point = credit_content[0]
        user.soso_point = credit_content[3]
        user.bad_point  = credit_content[5]
      end

      user.fetch_base_info

      expect(user.office_products_count.present?).to eq true
      expect(user.about.present?).to eq true
      expect(user.good_point.present?).to eq true
      expect(user.soso_point.present?).to eq true
      expect(user.bad_point.present?).to eq true
    end
  end

  describe '#fetch_products', type: :job do
    include ActiveJob::TestHelper
    before(:each) do
      allow(Ruten::User).to receive(:fetch_page).with("#{user.index_url}&p=1").and_return(index_html)
    end
    it 'can queues of each fetched product jobs' do
      expect { user.fetch_products }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by products_count
    end
  end
end
