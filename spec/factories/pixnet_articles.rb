FactoryGirl.define do
  factory :pixnet_article, class: 'Pixnet::Article' do

    trait :test do
      # skip validation callback
      after(:build) do |article|
        callbacks = article.class
                           ._validation_callbacks
                           .select { |cb| cb.kind.eql?(:before) }.collect(&:filter)

        if callbacks.include? :fetch_article_data
          article.class.skip_callback(:validation, :before, :fetch_article_data)
        end
      end

      user do
        create(:pixnet_user, :test)
      end
      origin_id '64756177' # 自己申請的痞客邦帳號的文章
    end
  end
end
