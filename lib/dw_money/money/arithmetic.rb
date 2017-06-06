module DwMoney
  class Money
    module Arithmetic
      [:+, :-, :*, :/].each do |math_operator|
        define_method(math_operator) do |other|
          raise TypeError unless other.is_a?(Money) || other.is_a?(Numeric)

          other = other.convert_to(currency).amount if other.is_a?(Money)
          Money.new(amount.public_send(math_operator, other), currency)
        end
      end
    end
  end
end
