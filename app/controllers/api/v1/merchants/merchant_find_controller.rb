class Api::V1::Merchants::MerchantFindController < ApplicationController
  def find
    merchant = Merchant.find_by_name(params[:name])
    if merchant.empty?
      render json: { errors: { data: 'no match'} }, status: 400

    else

      render json: MerchantSerializer.new(merchant.first)
    end
  end
end
