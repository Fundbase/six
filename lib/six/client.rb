module SIX
  class Client
    include HTTParty

    base_uri 'https://apidintegra.tkfweb.com'

    def initialize(ui, pwd)
      @ui = ui
      @id = login(pwd)
    end

    def hiku_data(listing_identifier,
                  price_type_set: Price::TypeSet::STANDARD,
                  price_quote_selection: Price::LAST_PRICE,
                  adjustment: Adjustment::ABSOLUTE,
                  date_from: 10.days.ago,
                  date_to: Date.current)

      response = request('getHikuData', ik: listing_identifier, pts: price_type_set, pk: price_quote_selection,
                         date_from: date_from, date_to: date_to, adj: adjustment)
      InstrumentList.new(response['IL']).instruments.first
    end
    alias_method :prices, :hiku_data

    def identify_instrument(isin)
      response = request('getListingID',ks: 'ISIN', k1: isin)['LCVL']['LCV']
      response['f'].to_i == 1 ? response['l'] : nil
    end

    def method_missing(method, query = {})
      request(method.to_s.camelize(:lower), query)
    end

  private

    # @return [String] session ID.
    def login(pwd)
      request('login', pwd: pwd)['A']['v']
    end

    def action(method, query = {})
      get(:action, method, query)
    end

    def request(method, query = {})
      get(:request, method, query)
    end

    def get(request_type, method, query)
      query        = format(query.merge(method: method, ui: @ui, id: @id))
      raw_response = self.class.get("/apid/#{request_type}", query: query)

      SIX::Response.new(raw_response)
    end

    def format(query)
      query.map do |key, value|
        formatted = case value
                      when Time, Date, DateTime
                        value.strftime('%d.%m.%Y')
                      else
                        value
                    end
        [key, formatted]
      end.to_h
    end
  end
end
