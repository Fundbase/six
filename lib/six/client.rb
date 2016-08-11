module SIX
  class Client
    include HTTParty

    base_uri 'http://apidprod.tkfweb.com'
    attr_accessor :exceptions

    def initialize(ui = ENV['SIX_UI'], pwd = ENV['SIX_PWD'])
      @ui = ui
      @id = login(pwd)
      @exceptions = []
    end

    # returns Instrument Object
    def identify_instrument(isin)
      response = request('getListingID', ks: 'ISIN', k1: isin)['LCVL']['LCV']
      if response['f'].to_i == 1
        SIX::Instrument.new(response['l'])
      else
        raise ArgumentError, "ISIN #{isin} isn't available on SIX listings"
      end
    end

    # rubocop:disable Metrics/ParameterLists, Metrics/MethodLength

    #returns a Hash with following this format {fund_id: price_object}
    def first_time_retrieve_prices(fund_classes)
      result = {}
      six_currency = SIX::Currency.new
      fund_classes.each do |fund_class|
        begin
          verify_isin_currency_existence(fund_class[:currency], fund_class[:currency])
          currency_code = six_currency.find_code(fund_class[:currency].upcase)
          instrument_id = identify_instrument(fund_class[:isin])
          valor_number = instrument_id.valor
          markets_ids = fetch_markets(valor_number, currency_code)
          instruments_list = SIX::InstrumentList.new
          instruments_list.generate_instruments(valor_number, currency_code, markets_ids)
          result[fund_class[:id]] = fetch_prices(instruments_list).most_updated
        rescue => e
          @exceptions << { fund_class_id: fund_class, message: e.message }
          next
        end
      end
      result
    end

    #returns a Hash with following thos format {fund_id: price_object}
    def fetch_prices_using_instruments(securities_with_instrument_id, historical: false)
      instrument_ids = securities_with_instrument_id.map{ |security| security[:instrument_identifier] }
      instruments = SIX::InstrumentList.new(instrument_ids)

      prices = unless historical
        fetch_prices(instruments).prices
      else
        fetch_prices(instruments, '12,0,0;12,0,1;12,0,2;12,0,3').prices
      end

      securities_with_instrument_id.each.with_object({}).with_index do |(security, result), index|
        if prices[index].value?
          result[security[:id]] = prices[index]
        else
          @exceptions << { fund_class_id: security, message: "SIX didn't return a price", status: prices[index].status }
        end
      end
    end

    def verify_isin_currency_existence(isin, currency)
      raise ArgumentError, 'ISIN is empty' if isin.blank?
      raise ArgumentError, 'Currency is empty' if currency.blank?
    end

    # returns array of strings(markets ids)
    def fetch_markets(valor_number, currency_code)
      data = request('searchListings', search: "valor=#{valor_number}", Cur: currency_code)
      Array.wrap(data['ILS']['ISD'][0]['IS']).map(&:first).map(&:last)
    end

    # returns PriceList Object
    def fetch_prices(instruments, pk= '12,0,0')
      instruments_params = instruments.price_request_params
      params = instruments_params.merge({
        ml: 'avail',
        pk: pk,  #12,0,0 means return price value only according to table 701
        psk: 'none',
        })
      response = request('getListingData', params)
      response.errors.each do |error|
        @exceptions << { fund_class_id: nil, message: 'SIX returned an error', status: error['k'], value: error['v'] }
      end if response.errors?
      SIX::PriceList.new(response['IL']['I'])
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
      query.each.with_object({}) do |(key, value), result|
        result[key] = value.try(:strftime, '%d.%m.%Y') || value
      end
    end
  end
end
