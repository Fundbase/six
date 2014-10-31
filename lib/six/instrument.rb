module SIX
  class Instrument
    include Errorable

    attr_accessor :value

    METHODS_NAMES = ['valor', 'exchange', 'currency']

    def initialize(value)
      @value = value
    end

    METHODS_NAMES.each_with_index do |method_name, index|
      define_method(method_name) do
        value.split(',')[index]
      end
    end

    private

    def errorable_object
      data
    end
  end
end
