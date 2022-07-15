require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'class methods' do
    it '#find_by_name finds all items that match a name' do
      merchant = Merchant.create!(name: 'Bobby Brown')
      item1 = create(:item, merchant_id: merchant.id, name: 'log')
      item2 = create(:item, merchant_id: merchant.id, name: 'stick')
      item3 = create(:item, merchant_id: merchant.id, name: 'tree')
      item4 = create(:item, merchant_id: merchant.id, name: 'sloth')

      expect(Item.find_by_name('lo')).to eq [item1, item4]
    end
  end
end
