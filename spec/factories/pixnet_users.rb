FactoryGirl.define do
  factory :pixnet_user, class: 'Pixnet::User' do

    trait :test do
      account 'tw145372' # 自己申請的痞客邦帳號
    end
  end
end
