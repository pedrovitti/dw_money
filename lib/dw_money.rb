require "dw_money/version"

module DwMoney
  class Money
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
  end
end
