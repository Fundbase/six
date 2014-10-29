module SIX
  class Client
    include HTTParty

    base_uri 'https://apidintegra.tkfweb.com'

    def initialize(ui, pwd)
      @ui = ui
      @id = login(pwd)
    end


    def identify_instrument(isin)
      response = request('getListingID', ks: 'ISIN', k1: isin)['LCVL']['LCV']
      response['f'].to_i == 1 ? SIX::Instrument.new(response['l']) : nil
    end

    def method_missing(method, query = {})
      request(method.to_s.camelize(:lower), query)
    end

    # rubocop:disable Metrics/ParameterLists, Metrics/MethodLength

    def first_time_retreive_prices(fund_classes)
      result = {}
      six_currency = SIX::Currency.new
      fund_classes.each do |fund_class|
        next if fund_class[:isin].nil? or fund_class[:currency].nil?
        currency_code = six_currency.find_code(fund_class[:currency])
        valor_number = identify_instrument(fund_class[:isin]).valor
        markets_ids = fetch_markets(valor_number, currency_code)
        instruments = SIX::InstrumentList.new(valor_number, currency_code, markets_ids)
        prices = fetch_prices(instruments)
        result[fund_class[:id]] = SIX::PriceList.new(prices).most_updated
      end
      result
    end

    def fetch_markets(valor_number, currency_code)
      return nil if valor_number.nil? || currency_code.nil?
      data = request('searchListings', search: "valor=#{valor_number}", Cur: currency_code)
      data['ILS']['ISD'][0]['IS'].map(&:first).map(&:last)
    end

    def fetch_prices(instruments)
      instruments_params = instruments.price_request_params
      params = instruments_params.merge({
        ml: 'avail',
        pk: '12,0,0',  #12,0,0 means return price value only according to table 701
        psk: 'none',
        })
      request('getListingData', params)['IL']['I']
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
