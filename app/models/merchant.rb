class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name(name)
    where('name ILIKE ?', "%#{name}%")
      .order(:name)
      .limit(1)
  end
end
