class Api::V1::ItemMerchantsController < ApplicationController
  def show
    item = Item.find(params[:item_id])
    merchant = Merchant.find(item.merchant.id)
    render json: MerchantSerializer.new(merchant)
  end
end
