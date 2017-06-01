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
      raise ConversionRateNotFound, new_currency unless rates[new_currency]

      new_amount = amount * rates[new_currency]
      Money.new(new_amount, new_currency)
    end

    def <=>(other)
      other.amount.round(2) <=> amount.round(2)
    end

    private

    def rates
      @@conversion_rates[currency]
    end
  end
end
