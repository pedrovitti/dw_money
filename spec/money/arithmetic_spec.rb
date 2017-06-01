require 'spec_helper'

describe DwMoney::Money do
  describe '#+' do
    context 'when Money or Numeric objects' do
      context 'when same currency' do
        it 'adds new amount to current amount' do
          expect(DwMoney::Money.new(10.02, 'USD') + DwMoney::Money.new(10.90, 'USD'))
            .to eq DwMoney::Money.new(20.92, 'USD')
        end
      end

      context 'when different currencies' do
        context 'with a conversion rate' do
          before { DwMoney::Money.conversion_rates('EUR', 'USD' => 1.12, 'BRL' => 3.51) }

          it 'adds converted amount to current amount in current currency' do
            expect(DwMoney::Money.new(10.20, 'USD') + DwMoney::Money.new(90, 'EUR'))
              .to eq DwMoney::Money.new(111.00, 'USD')
          end
        end

        context 'without a conversion rate' do
          it 'raises error' do
            expect { DwMoney::Money.new(10.20, 'USD') + DwMoney::Money.new(90, 'XUN') }
              .to raise_error(DwMoney::ConversionRateNotFound, 'USD => XUN')
          end
        end
      end

      context 'when numeric value' do
        it 'adds numeric value to amount and returns' do
          expect(DwMoney::Money.new(30, 'EUR') + 10).to eq DwMoney::Money.new(40, 'EUR')
        end
      end
    end

    context 'when not Money or Numeric object' do
      it 'raises an error' do
        expect { DwMoney::Money.new(10.02, 'USD') + 'pedro' }.to raise_error(TypeError)
      end
    end
  end

  describe '#-' do
    context 'when Money or Numeric objects' do
      context 'when same currency' do
        it 'subtracts new amount to current amount' do
          expect(DwMoney::Money.new(10.02, 'USD') - DwMoney::Money.new(10.90, 'USD'))
            .to eq DwMoney::Money.new(-0.88, 'USD')
        end
      end

      context 'when different currencies' do
        context 'with a conversion rate' do
          before { DwMoney::Money.conversion_rates('EUR', 'USD' => 1.12, 'BRL' => 3.51) }

          it 'subtracts converted amount to current amount in current currency' do
            expect(DwMoney::Money.new(140.20, 'USD') - DwMoney::Money.new(90, 'EUR'))
              .to eq DwMoney::Money.new(39.40, 'USD')
          end
        end

        context 'without a conversion rate' do
          it 'raises error' do
            expect { DwMoney::Money.new(10.20, 'USD') - DwMoney::Money.new(90, 'XUN') }
              .to raise_error(DwMoney::ConversionRateNotFound, 'USD => XUN')
          end
        end
      end

      context 'when numeric value' do
        it 'subtracts numeric value to amount and returns' do
          expect(DwMoney::Money.new(31, 'EUR') - 10.90).to eq DwMoney::Money.new(20.10, 'EUR')
        end
      end
    end

    context 'when not Money or Numeric object' do
      it 'raises an error' do
        expect { DwMoney::Money.new(10.02, 'USD') - 'pedro' }.to raise_error(TypeError)
      end
    end
  end

  describe '#/' do
    context 'when Money or Numeric objects' do
      context 'when same currency' do
        it 'divides new amount to current amount' do
          expect(DwMoney::Money.new(10.02, 'USD') / DwMoney::Money.new(-10.90, 'USD'))
            .to eq DwMoney::Money.new(-0.92, 'USD')
        end
      end

      context 'when different currencies' do
        context 'with a conversion rate' do
          before { DwMoney::Money.conversion_rates('EUR', 'USD' => 1.12, 'BRL' => 3.51) }

          it 'divides converted amount to current amount in current currency' do
            expect(DwMoney::Money.new(140.20, 'USD') / DwMoney::Money.new(90, 'EUR'))
              .to eq DwMoney::Money.new(1.39, 'USD')
          end
        end

        context 'without a conversion rate' do
          it 'raises error' do
            expect { DwMoney::Money.new(10.20, 'USD') / DwMoney::Money.new(90, 'XUN') }
              .to raise_error(DwMoney::ConversionRateNotFound, 'USD => XUN')
          end
        end
      end

      context 'when numeric value' do
        it 'divides numeric value to amount and returns' do
          expect(DwMoney::Money.new(61, 'EUR') / 10.90).to eq DwMoney::Money.new(5.60, 'EUR')
        end
      end
    end

    context 'when not Money or Numeric object' do
      it 'raises an error' do
        expect { DwMoney::Money.new(10.02, 'USD') / 'pedro' }.to raise_error(TypeError)
      end
    end
  end

  describe '#*' do
    context 'when Money or Numeric objects' do
      context 'when same currency' do
        it 'multiplies new amount to current amount' do
          expect(DwMoney::Money.new(10.02, 'USD') * DwMoney::Money.new(-10.90, 'USD'))
            .to eq DwMoney::Money.new(-109.22, 'USD')
        end
      end

      context 'when different currencies' do
        context 'with a conversion rate' do
          before { DwMoney::Money.conversion_rates('EUR', 'USD' => 1.12, 'BRL' => 3.51) }

          it 'multiplies converted amount to current amount in current currency' do
            expect(DwMoney::Money.new(140.20, 'USD') * DwMoney::Money.new(90, 'EUR'))
              .to eq DwMoney::Money.new(14_132.16, 'USD')
          end
        end

        context 'without a conversion rate' do
          it 'raises error' do
            expect { DwMoney::Money.new(10.20, 'USD') * DwMoney::Money.new(90, 'XUN') }
              .to raise_error(DwMoney::ConversionRateNotFound, 'USD => XUN')
          end
        end
      end

      context 'when numeric value' do
        it 'multiplies numeric value to amount and returns' do
          expect(DwMoney::Money.new(31, 'EUR') * 10.90).to eq DwMoney::Money.new(337.90, 'EUR')
        end
      end
    end

    context 'when not Money or Numeric object' do
      it 'multiplies an error' do
        expect { DwMoney::Money.new(10.02, 'USD') * 'pedro' }.to raise_error(TypeError)
      end
    end
  end

  describe 'comparing money objects' do
    DwMoney::Money.conversion_rates('EUR', 'USD' => 1.12, 'BRL' => 3.51)
    DwMoney::Money.conversion_rates('USD', 'EUR' => 0.89, 'BRL' => 3.41)

    let(:money) { DwMoney::Money.new(11.42, 'USD') }

    context 'when same currency' do
      context 'with same amount' do
        let(:other) { DwMoney::Money.new(11.42, 'USD') }

        it { expect(money).to eq other }
      end

      context 'with different amount' do
        let(:other) { DwMoney::Money.new(1.20, 'USD') }

        it { expect(money).to_not eq other }
      end

      context 'with higher amount' do
        let(:other) { DwMoney::Money.new(100.20, 'USD') }

        it { expect(money).to be < other }
      end

      context 'with lower amount' do
        let(:other) { DwMoney::Money.new(1.20, 'USD') }

        it { expect(money).to be > other }
      end
    end

    context 'with different currency' do
      context 'with same converted amount' do
        let(:other) { DwMoney::Money.new(10.20, 'EUR') }

        it { expect(money).to eq other }
      end

      context 'with different converted amount' do
        let(:other) { DwMoney::Money.new(60.20, 'EUR') }

        it { expect(money).to_not eq other }
      end

      context 'with higher converted amount' do
        let(:other) { DwMoney::Money.new(123.20, 'USD') }

        it { expect(money).to be < other }
      end

      context 'with lower converted amount' do
        let(:other) { DwMoney::Money.new(10.20, 'USD') }

        it { expect(money).to be > other }
      end
    end
  end
end
