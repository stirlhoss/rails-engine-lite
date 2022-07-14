require 'rails_helper'

RSpec.describe 'find for merchant endpoint' do
  describe 'happy path' do
    it 'returns one merchant based on search params' do
      merchant1 = create(:merchant, name: 'Pilson & Sons')
      merchant2 = create(:merchant, name: 'Joe Schlick HVAC')
      merchant3 = create(:merchant, name: 'Willies Big Rigs')
      merchant4 = create(:merchant, name: 'Porky Bob')

      get api_v1_merchants_find_path, params: { name: 'P' }

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to eq('Pilson & Sons')
    end
  end

  describe 'sad path' do
    it 'raises error when there is no match' do
      get '/api/v1/merchants/find', params: { name: '@' }

      expect(response.status).to eq(204)
    end
  end
end
