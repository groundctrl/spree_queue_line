FactoryGirl.modify do
  factory :order do
    trait :guest do
      user nil
      email { generate(:random_email) }
      guest_token { SecureRandom.hex }
    end
  end
end
