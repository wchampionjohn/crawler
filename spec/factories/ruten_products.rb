FactoryGirl.define do
  factory :ruten_product, class: 'Ruten::Product' do
    trait :test do
      # skip validation callback
      after(:build) do |product|
        callbacks = product.class
                           ._validation_callbacks
                           .select { |cb| cb.kind.eql?(:before) }.collect(&:filter)

        if callbacks.include? :fetch_remote_data
          product.class.skip_callback(:validation, :before, :fetch_remote_data)
        end
      end

      user do
        build(:ruten_user, :test)
      end
      origin_id '21507497287002' # 某個確實存在於露天網站的商品
    end
  end
end
