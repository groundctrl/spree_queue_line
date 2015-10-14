FactoryGirl.modify do
  factory :order do
    trait :guest do
      user nil
      email { generate(:random_email) }
      guest_token { SecureRandom.hex }
    end

  end

  factory :order_with_line_items do
    after(:create) do |order, evaluator|
      order.updater.update_item_count
      order.updater.update
    end
  end
end
