module Services
  class RequestManager

    module API_CONFIG
      URL = "https://api.blah.com/api"
      API_VERSION = "2"
    end

    def initialize(city, id=nil)
      @city = city
      @id = id
    end

    def all_deal
      "#{API_CONFIG::URL}/#{API_CONFIG::API_VERSION}/#{@city}/all"
    end

    def selected_deal
      "#{API_CONFIG::URL}/#{API_CONFIG::API_VERSION}/#{@city}/deals/#{@id}"
    end

  end
end
