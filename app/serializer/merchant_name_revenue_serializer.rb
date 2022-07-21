class MerchantNameRevenueSerializer
  include JSONAPI::ItemSerializer
  attributes :name

  attributes :revenue do |merchant|
    merchant.revenue
  end
end
