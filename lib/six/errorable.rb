module SIX
  module Errorable
    def error?
      errorable_object['A'] && errorable_object['A']['k'] &&
          errorable_object['A']['k'].match(/\Ae\d+\z/)
    end

    def raise_error!
      fail SIX::Error, error
    end

    def error
      errorable_object['A']['v']
    end

    private

    def errorable_object
      self
    end
  end
end
