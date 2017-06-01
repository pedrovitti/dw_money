require "dw_money/version"

module DwMoney
  class ConversionRateNotFound < StandardError; end

  class Money
    include Comparable

    attr_reader :amount, :currency

    @@conversion_rates = {}

    def self.conversion_rates(base_currency, rates)
      @@conversion_rates[base_currency] = rates
    end

    def initialize(amount, currency)
      @amount = amount
      @currency = currency
    end

    def inspect
      "#{'%.2f' % amount} #{currency}"
    end

    def convert_to(new_currency)
      return self if new_currency == currency

      raise ConversionRateNotFound, "#{new_currency} => #{currency}" unless rates && rates[new_currency]

      new_amount = amount * rates[new_currency]
      Money.new(new_amount, new_currency)
    end

    def <=>(other)
      other.amount.round(2) <=> amount.round(2)
    end

    def +(other)
      raise TypeError unless (other.is_a?(Money) || other.is_a?(Numeric))

      other = other.convert_to(currency).amount if other.is_a?(Money)

      Money.new(amount + other, currency)
    end

    private

    def rates
      @@conversion_rates[currency]
    end
  end
end
