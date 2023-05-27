class DealsController < ApplicationController

  CURRENTLY_ACCEPTED_CITIES = ['Glasgow', 'Edinburgh', 'Dundee']

  def index
    @message = I18n.t('infos.select_city')
  end

  def get_deals_of_city
    if CURRENTLY_ACCEPTED_CITIES.include?(city_deals_search_params[:name_of_city])
      request_params = { :method => :get, :url => "https://api.itison.com/api/110/#{city_deals_search_params[:name_of_city]}/all" }
      response = RestClient::Request.execute(request_params)
      @deals = JSON.parse(response.body)

      @city = city_deals_search_params[:name_of_city]
      @filter = city_deals_search_params[:filter]
    else
      flash[:alert] = I18n.t('errors.no_available_even_or_deal')
      redirect_to root_path
    end
  end

  def show

    id_of_deal = params[:data_of_deal][:deal].nil? ? params[:data_of_deal][:event][:id] : params[:data_of_deal][:deal][:id]
    place_of_deal = params[:location]

    unless id_of_deal && place_of_deal == nil
      request_params = { :method => :get, :url => "https://www.itison.com/api/110/#{place_of_deal}/deals/#{id_of_deal}" }
      response = RestClient::Request.execute(request_params)
      @deal = JSON.parse(response.body)
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

end
