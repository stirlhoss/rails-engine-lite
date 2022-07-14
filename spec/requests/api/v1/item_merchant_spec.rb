require 'rails_helper'

RSpec.describe 'Item merchant' do
  describe 'happy path' do
    it 'returns the merchant for an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      expect(merchant.items.count).to eq 6

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merchant_json = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_json[:data]).to be_a(Hash)
      expect(merchant_json[:data][:id]).to be_a(String)
      expect(merchant_json[:data][:attributes][:name]).to be_a(String)

    end
  end

  describe 'sad path' do
    it 'returns an error when the id is unavailable' do
      get '/api/v1/items/1000000000000000/merchant'

      expect(response.status).to eq(404)
    end
  end
end
