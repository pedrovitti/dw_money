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

  describe "#convert_to" do
    before do
      DwMoney::Money.conversion_rates("EUR", { 'USD' => 1.12, 'BRL' => 3.51 })
    end

    context "when converting money" do
      let(:fifty_euros) { DwMoney::Money.new(50.12, "EUR") }

      context "to an existing currency" do
        it "returns money with converted amount and currency" do
          expect(fifty_euros.convert_to("USD")).to eq DwMoney::Money.new(56.13, "USD")
        end
      end

      context "to a non-existing currency" do
        it "raises and error" do
          expect { fifty_euros.convert_to("XUN") }.to raise_error(DwMoney::ConversionRateNotFound, "XUN => EUR")
        end
      end
    end
  end

  describe "#+" do

    context "when Money or Numeric objects" do

      context "when same currency" do
        it "adds new amount to current amount" do
          expect(DwMoney::Money.new(10.02, "USD") + DwMoney::Money.new(10.90, "USD")).to eq DwMoney::Money.new(20.92, "USD")
        end
      end

      context "when different currencies" do

        context "with a conversion rate" do
          before { DwMoney::Money.conversion_rates("EUR", { 'USD' => 1.12, 'BRL' => 3.51 }) }

          it "adds converted amount to current amount in current currency" do
            expect(DwMoney::Money.new(10.20, "USD") + DwMoney::Money.new(90, "EUR")).to eq DwMoney::Money.new(111.00, "USD")
          end
        end

        context "without a conversion rate" do
          it "raises error" do
            expect { DwMoney::Money.new(10.20, "USD") + DwMoney::Money.new(90, "XUN") }
              .to raise_error(DwMoney::ConversionRateNotFound, "USD => XUN")
          end
        end

      end

      context "when numeric value" do
        it "adds numeric value to amount and returns" do
          expect(DwMoney::Money.new(30, "EUR") + 10).to eq DwMoney::Money.new(40, "EUR")
        end
      end

    end

    context "when not Money or Numeric object" do
      it "raises an error" do
        expect { DwMoney::Money.new(10.02, "USD") + "pedro" }.to raise_error(TypeError)
      end
    end

   end
end
