require "spec_helper"

describe DwMoney::Money do

  describe ".conversion_rates" do

    it "configures rates for base currency" do
      expected_rates = {
        "BRL" => { 'EUR' => 0.28, 'USD' => 0.31 },
        'EUR' => { 'USD' => 1.12, 'BRL' => 3.51 }
      }

      DwMoney::Money.conversion_rates("BRL", expected_rates["BRL"])
      DwMoney::Money.conversion_rates("EUR", expected_rates["EUR"])

      expect(DwMoney::Money.class_variable_get :@@conversion_rates).to eq(expected_rates)
    end

  end

  describe "#inspect" do
    subject { DwMoney::Money.new(50.12, "EUR").inspect }

    it "returns a readable version of amount and currency" do
      expect(subject).to eq "50.12 EUR"
    end
  end

end
