class Api::V1::Items::ItemsFindController < ApplicationController

  def find_all
    if params[:name].empty?
      render json: { data: {}, error: 'no search params' }, status: 204
    else
    items_name = Item.find_by_name(params[:name])
    render json: ItemSerializer.new(items_name)
    end
  end
end
