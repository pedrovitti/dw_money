require 'spec_helper'

describe DwMoney::Money do
  describe '.conversion_rates' do
    it 'configures rates for base currency' do
      expected_rates = {
        'BRL' => { 'EUR' => 0.28, 'USD' => 0.31 },
        'EUR' => { 'USD' => 1.12, 'BRL' => 3.51 }
      }

      DwMoney::Money.conversion_rates('BRL', expected_rates['BRL'])
      DwMoney::Money.conversion_rates('EUR', expected_rates['EUR'])

      expect(DwMoney::Money.class_variable_get(:@@conversion_rates)).to include(expected_rates)
    end
  end

  describe '#inspect' do
    subject { DwMoney::Money.new(50.12, 'EUR').inspect }

    it 'returns a readable version of amount and currency' do
      expect(subject).to eq '50.12 EUR'
    end
  end

  describe '#convert_to' do
    before do
      DwMoney::Money.conversion_rates('EUR', 'USD' => 1.12, 'BRL' => 3.51)
    end

    context 'when converting money' do
      let(:fifty_euros) { DwMoney::Money.new(50.12, 'EUR') }

      context 'to an existing currency' do
        it 'returns money with converted amount and currency' do
          expect(fifty_euros.convert_to('USD')).to eq DwMoney::Money.new(56.13, 'USD')
        end
      end

      context 'to a non-existing currency' do
        it 'raises and error' do
          expect { fifty_euros.convert_to('XUN') }.to raise_error(DwMoney::ConversionRateNotFound, 'XUN => EUR')
        end
      end
    end
  end
end
