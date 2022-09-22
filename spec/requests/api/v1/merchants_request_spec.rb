require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  describe 'merchats#show' do
    describe 'happy path' do
      it 'gets the merchant' do
        create_list(:merchant, 3)

        get api_v1_merchant_path(Merchant.last.id)

        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to be_an(String)
        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_an(String)
      end
    end

    describe 'sad path' do
      it 'gives a 404 error when id is invalid' do
        create_list(:merchant, 3)

        get api_v1_merchant_path(1)

        expect(response.status).to eq(404)
      end
    end
  end
end
