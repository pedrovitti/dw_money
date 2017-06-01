require "dw_money/version"

module DwMoney
  class Money

    @@conversion_rates = {}

    def self.conversion_rates(base_currency, rates)
      @@conversion_rates[base_currency] = rates
    end

  end
end
