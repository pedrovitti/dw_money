require 'dw_money/money/arithmetic'

module DwMoney
  class ConversionRateNotFound < StandardError; end

  class Money
    include Comparable
    include Money::Arithmetic

    attr_reader :amount, :currency

    @conversion_rates = {}

    def self.conversion_rates(base_currency, rates)
      @conversion_rates[base_currency] = rates
    end

    def initialize(amount, currency)
      @amount = amount
      @currency = currency
    end

    def inspect
      "#{format('%.2f', amount)} #{currency}"
    end

    def convert_to(new_currency)
      return self if new_currency == currency

      raise ConversionRateNotFound, "#{new_currency} => #{currency}" unless rates && rates[new_currency]

      new_amount = amount * rates[new_currency]
      Money.new(new_amount, new_currency)
    end

    def self.conversion_rates_configuration
      @conversion_rates
    end

    private

    def rates
      self.class.conversion_rates_configuration[currency]
    end

  end
end
