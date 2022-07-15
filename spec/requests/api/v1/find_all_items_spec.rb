require 'rails_helper'

RSpec.describe 'find all items' do
  it 'returns all items that match a search param' do
    merchant = Merchant.create!(name: 'Bobby Brown')
    item1 = create(:item, merchant_id: merchant.id, name: 'log')
    item2 = create(:item, merchant_id: merchant.id, name: 'stick')
    item3 = create(:item, merchant_id: merchant.id, name: 'tree')
    item4 = create(:item, merchant_id: merchant.id, name: 'sloth')

    get api_v1_items_find_all_path, params: { name: 'lo' }

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 2
  end

  it 'has a sad path' do
    merchant = Merchant.create!(name: 'Bobby Brown')
    item1 = create(:item, merchant_id: merchant.id, name: 'log')
    item2 = create(:item, merchant_id: merchant.id, name: 'stick')
    item3 = create(:item, merchant_id: merchant.id, name: 'tree')
    item4 = create(:item, merchant_id: merchant.id, name: 'sloth')

    get api_v1_items_find_all_path, params: { name: '' }

    expect(response.status).to eq(204)
  end
end
