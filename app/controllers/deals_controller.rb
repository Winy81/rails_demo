class DealsController < ApplicationController

  CURRENTLY_ACCEPTED_CITIES = ['Glasgow', 'Edinburgh', 'Dundee']

  def index
    @message = I18n.t('infos.select_city')
  end

  def get_deals_of_city

    if CURRENTLY_ACCEPTED_CITIES.include?(city_deals_search_params[:name_of_city])

      @city = city_deals_search_params[:name_of_city]
      @filter = city_deals_search_params[:filter]

      request_params = { :method => :get, :url => Services::RequestManager.new(@city).all_deal}
      response = request_execution(request_params)

      @deals = JSON.parse(response.body)
    else
      flash[:alert] = I18n.t('errors.no_available_even_or_deal')
      redirect_to root_path
    end
  end

  def show

    id_of_deal = params[:data_of_deal]
    place_of_deal = params[:location]

    unless id_of_deal && place_of_deal == nil
      local_storage_response = Services::LocalStorageManager.new(id_of_deal).fetch

      if local_storage_response.nil?
        request_params = { :method => :get, :url =>  Services::RequestManager.new(place_of_deal, id_of_deal).selected_deal}
        response = request_execution(request_params)
        @deal = JSON.parse(response.body)
        Services::LocalStorageManager.new(id_of_deal, @deal).load
      else
        @deal = JSON.parse(formatted_sored_response(local_storage_response))
      end
    else
      flash[:alert] = I18n.t('errors.not_enough_information')
      redirect_to root_path
    end
  end

  private

  def city_deals_search_params
    if params.has_key?(:city)
      params.require(:city).permit(:name_of_city)
    elsif params.has_key?(:filtered_city_params)
      params.require(:filtered_city_params).permit(:name_of_city, :filter)
    end
  end

  def formatted_sored_response(response)
    response.gsub("=>", ":").gsub(/\bnil\b/, "null")
  end

  def request_execution(params)
    RestClient::Request.execute(params)
  end

end
