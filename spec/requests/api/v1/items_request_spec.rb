require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'get all items' do
    it 'sends a list of all items' do
      create_list(:merchant, 3)

      get '/api/v1/items'

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

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  end

  describe 'get one item' do
    describe 'happy path' do
      it 'can get the information for 1 item' do
        create_list(:merchant, 1)
        test_item = create(:item, merchant_id: Merchant.last.id, name: 'cereal')

        get api_v1_item_path(test_item.id)

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to be_an(String)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_an(String)
        expect(item[:data][:attributes][:name]).to eq('cereal')

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_an(String)

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_an(Float)
      end
    end

    describe 'sad path' do
      it 'returns the proper error when item does not exist' do
        create_list(:merchant, 3)

        get api_v1_item_path(5_000_000_000_000_000)

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'create/destroy' do
    it 'can create a new item and destroy that item' do
      test_merchant = create(:merchant)
      item_params = {
        name: 'cereal',
        description: 'a morning delight',
        unit_price: 3.50,
        merchant_id: test_merchant.id
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      # We include this header to make sure that these params are passed as JSON rather than as plain text
      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(Item.all.count).to eq 6

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      delete "/api/v1/items/#{created_item.id}"

      expect(response).to be_successful

      expect(Item.all.count).to eq 5
    end

    it 'can delete empty invoices associated with deleted items' do
      merchant = Merchant.create!(name: 'Bobby Brown')
      item = create(:item, merchant_id: merchant.id)
      customer = Customer.create!(first_name: 'Steve', last_name: 'Bengels')
      invoice = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      inv_items = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 5, unit_price: 10.15)

      expect(Item.count).to eq 1
      expect(Invoice.count).to eq 1

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq 0
      expect(Invoice.count).to eq 0
    end
  end

  describe 'update' do
    describe 'happy path' do
      it 'can update an existing item' do
        test_merchant = create(:merchant)
        test_item = create(:item,
                           name: 'cereal',
                           description: 'a morning delight',
                           unit_price: 3.50,
                           merchant_id: test_merchant.id)

        previous_name = test_item.name
        item_params = { name: 'cold oatmeal' }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        # We include this header to make sure that these params are passed as JSON rather than as plain text
        patch "/api/v1/items/#{test_item.id}", headers: headers, params: JSON.generate({ item: item_params })
        new_item = Item.find_by(id: test_item.id)

        new_name = 'cold oatmeal'

        expect(response).to be_successful
        expect(new_item.name).to_not eq(previous_name)
        expect(new_item.name).to eq(new_name)
      end
    end

    describe 'sad path' do
      it 'returns the correct error' do
        create_list(:merchant, 3)

        item_params = { name: 'cold oatmeal' }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/items/50000000000000000", headers: headers, params: JSON.generate({ item: item_params })

        expect(response.status).to eq(404)
      end
    end
  end
end
