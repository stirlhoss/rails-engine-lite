class Api::V1::Merchants::MerchantFindController < ApplicationController
  def find
    merchant = Merchant.find_by_name(params[:name])
    if !merchant.empty?
      render json: MerchantSerializer.new(merchant.first)

    elsif params[:name].blank?
      render json: { errors: { data: 'no search parameters' } }, status: 400

    else
      render json: MerchantSerializer.no_match(params[:name])

    end
  end
end
