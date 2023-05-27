class DealsController < ApplicationController

  ACCEPTED_CITIES = ['Glasgow', 'Edinburgh', 'Dundee']

  def index
    @message = 'Please add the name of the City for get deals'
  end

  def get_deals_of_city

    if ACCEPTED_CITIES.include?(city_deals_search_params[:name_of_city])
      request_params = { :method => :get, :url => "https://api.itison.com/api/110/#{city_deals_search_params[:name_of_city]}/all" }
      response = RestClient::Request.execute(request_params)
      @deals = JSON.parse(response.body)

      @city = city_deals_search_params[:name_of_city]
    else
      flash[:alert] = 'Deals for this city are not available at this moment'
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
      flash[:alert] = 'Not enough details to provide further information'
      redirect_to root_path
    end
  end

  private

  def city_deals_search_params
    params.require(:city).permit(:name_of_city)
  end

end
