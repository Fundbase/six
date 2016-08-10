module SIX
  module Errorable
    def errors?
      # there's some error node with a "e1234"-like attribute 'k'
      error_node.present? && error_node.any? { |e| e['k'].try(:=~, /\Ae\d+\z/) }
    end

    def raise_error!
      fail SIX::Error, errors
    end

    def errors
      error_node if errors?
    end

    private

    def error_node
      # error nodes ('A') can be under 'XRF' or directly in 'A'
      # e.g.
      # "XRF"=>{"A"=>[{"k"=>"e0008", "v"=>"abc4855464,354,814"}, {"k"=>"e0008", "v"=>"def2241864,47,814"}]}
      Array.wrap(errorable_object['A'] || errorable_object['XRF'].try(:[], 'A'))
    end

    def errorable_object
      self
    end
  end
end
