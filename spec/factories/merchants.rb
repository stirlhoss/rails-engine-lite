FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    after :create do |merchant|
      5.times { merchant.items << FactoryBot.create(:item) }
    end
  end
end
