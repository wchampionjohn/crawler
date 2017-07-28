require 'rails_helper'
require 'vcr_helper'
require 'support/ruten_helpers'

RSpec.describe Ruten::Product, type: :model do
  let(:product) do
    build(:ruten_product, :test)
  end

  let(:product_response) do
    VCR.use_cassette 'ruten product' do
      fetch_page(product.detail_url)
    end
  end

  let(:product_html) do
    Nokogiri::HTML(product_response.body)
  end

  let(:product_params) do
    {
      title: product_html.css('div .main-content h1').first.text,
      price: product_html.css('strong.price').text.delete(','),
      sale_out_num: product_html.css('table.item-detail-table tr td')[1].text.strip,
      pay_way: product_html.css('table.item-detail-table tr td')[3].text.strip.gsub(/\n/,'').split.join(' / '),
      transport_way: product_html.css('table.item-detail-table tr td')[5].text.strip.split("\n").first,
      situation: product_html.css('ul#product-memo li')[0].text.split('：').last.delete(' '),
      location: product_html.css('ul#product-memo li')[1].text.split('：').last.delete(' '),
      launched_date: product_html.css('ul#product-memo li')[2].text.split('：').last.gsub(/^ /,''),
      remote_main_img_url: product_html.css('div.item-gallery-main-image img').first['src'].gsub('_m.', '.')
    }
  end

  describe 'fetch product from ruten product page' do
    it 'returns a 200 OK status' do
      expect(product_response.code).to eq('200')
    end
    it 'can parse product title' do
      expect(product_params[:title].blank?).to eq false
    end
    it 'can parse product price' do
      expect(product_params[:price].blank?).to eq false
    end
    it 'can parse product sale out number' do
      expect(product_params[:sale_out_num].blank?).to eq false
    end
    it 'can parse product pay way' do
      expect(product_params[:pay_way].blank?).to eq false
    end
    it 'can parse product transport way' do
      expect(product_params[:transport_way].blank?).to eq false
    end
    it 'can parse product situation' do
      expect(product_params[:situation].blank?).to eq false
    end
    it 'can parse product location' do
      expect(product_params[:location].blank?).to eq false
    end
    it 'can parse product launched_date' do
      expect(product_params[:launched_date].blank?).to eq false
    end
    it 'can parse product main images' do
      expect(product_params[:remote_main_img_url]).to match(/^http(.)+.(jpg|jpeg|gif|png)$/i)
    end
  end

  describe 'writes product from ruten product page' do
    let(:fetch_remote_product) do
      allow(Ruten::Product).to receive(:fetch_page).and_return(product_html)
      product.fetch_remote_data
    end

    it 'can fetch and write product title' do
      expect { fetch_remote_product }.to change { product.title.blank? }.from(true).to false
    end

    it 'can fetch and write product price' do
      expect { fetch_remote_product }.to change { product.price.blank? }.from(true).to false
    end

    it 'can fetch and write product sale out number' do
      expect { fetch_remote_product }.to change { product.sale_out_num.blank? }.from(true).to false
    end

    it 'can fetch and write product pay way' do
      expect { fetch_remote_product }.to change { product.pay_way.blank? }.from(true).to false
    end

    it 'can fetch and write product transport way' do
      expect { fetch_remote_product }.to change { product.transport_way.blank? }.from(true).to false
    end

    it 'can fetch and write product situation' do
      expect { fetch_remote_product }.to change { product.situation.blank? }.from(true).to false
    end

    it 'can fetch and write product location' do
      expect { fetch_remote_product }.to change { product.location.blank? }.from(true).to false
    end

    it 'can fetch and write product lanched_date' do
      expect { fetch_remote_product }.to change { product.launched_date.blank? }.from(true).to false
    end

    it 'can fetch and write product main image' do
      expect { fetch_remote_product }.to change { product.remote_main_img_url.blank? }.from(true).to false
    end
  end
end
