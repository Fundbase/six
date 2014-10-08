module SIX
  class Response < SimpleDelegator
    include Errorable

    def initialize(object)
      super
      validate!
    end

    def validate!
      raise SIX::Error, body if code != 200
      raise_error! if has_error?
    end

    def [](key)
      __getobj__['XRF'][key]
    end
  end
end
