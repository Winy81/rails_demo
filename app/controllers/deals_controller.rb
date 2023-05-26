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
    else
      flash[:alert] = 'Deals for this city are not available at this moment'
      redirect_to root_path
    end
  end

  private

  def city_deals_search_params
    params.require(:city).permit(:name_of_city)
  end

end
