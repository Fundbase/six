module SIX
  class Currency

    def initialize
      config_path = File.expand_path('config/currency.yml', File.dirname(__FILE__))
      @codes = YAML.load_file(config_path)['currency']
    end

    def find_code(currency)
      @codes[currency]
    end

  end
end
