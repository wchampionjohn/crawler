class Pixnet::Image < ApplicationRecord
  include Pixnet
  belongs_to :article
  mount_uploader :img, ::ArticleImgUploader

  validates :url, presence: true

  after_validation :set_image_url, on: :create

  def set_image_url
    self.remote_img_url = self.url
  end
end
