require 'rails_helper'

RSpec.describe "MerchantItems", type: :request do
  describe 'index merchants items' do
    describe 'happy path' do
      it 'gets all of a merchants items' do
        create_list(:merchant, 2)

        get api_v1_merchant_items_path(Merchant.last.id)

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        items[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_an(String)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_an(String)

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_an(String)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_an(Float)
        end
      end
    end
  end
end
