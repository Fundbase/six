module SIX
  # A wrapper for HTTParty::Response which
  # provide some convenience methods.
  class Response < SimpleDelegator
    include Errorable

    def initialize(object)
      super
      validate!
    end

    def validate!
      fail SIX::Error, body if code != 200
    end

    def [](key)
      __getobj__['XRF'][key]
    end
  end
end
