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
    it 'find_by_name finds all items that match a name' do
      merchant = Merchant.create!(name: 'Bobby Brown')
      item1 = create(:item, merchant_id: merchant.id, name: 'log')
      item2 = create(:item, merchant_id: merchant.id, name: 'stick')
      item3 = create(:item, merchant_id: merchant.id, name: 'tree')
      item4 = create(:item, merchant_id: merchant.id, name: 'sloth')

      expect(Item.find_by_name('lo')).to eq [item1, item4]
    end
  end

  describe 'instance methods' do
    it '#delete_empty_invoices' do
      merchant = Merchant.create!(name: 'Bobby Brown')
      item = create(:item, merchant_id: merchant.id)
      customer = Customer.create!(first_name: 'Steve', last_name: 'Bengels')
      invoice = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      inv_items = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 5, unit_price: 10.15)

      expect(Invoice.count).to eq(1)

      item.delete_empty_invoices

      expect(Invoice.count).to eq(0)
    end
  end
end
