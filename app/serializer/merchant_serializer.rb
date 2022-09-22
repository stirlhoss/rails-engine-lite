class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def self.no_match(name)
    { data: {}, errors: "Could not find merchant that matched with #{name}" }
  end
end
