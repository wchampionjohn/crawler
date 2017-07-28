FactoryGirl.define do
  factory :ruten_user, class: 'Ruten::User' do

    trait :test do
      account 'doris810520' # 某個已存在的露天賣家
    end
  end
end
