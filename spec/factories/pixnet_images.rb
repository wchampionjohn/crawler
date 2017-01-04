FactoryGirl.define do
  factory :pixnet_image, class: 'Pixnet::Image' do
    after(:build) do |image|
      callbacks = image.class
        ._validation_callbacks
        .select { |cb| cb.kind.eql?(:before) }.collect(&:filter)

      if callbacks.include? :fetch_article_data
        image.class.skip_callback(:validation, :before, :set_image_url)
      end
    end

    factory :user_with_set_image_url do
      before(:save) { |img| img.send(:set_image_url) }
    end

  end
end
