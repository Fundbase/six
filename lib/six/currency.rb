module SIX
  class Currency

    def initialize
      config_path = File.expand_path('config/currency.yml', File.dirname(__FILE__))
      @codes = YAML.load_file(config_path)['currency']
    end

    def find_code(currency)
      code = @codes[currency]
      if code.nil?
        raise Exception, "Couldn't find Code number for Currency #{currency} on SIX" if code.nil?
      else
        code
      end
    end

  end
end
