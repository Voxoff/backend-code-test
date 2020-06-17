require 'spec_helper'
require 'checkout'

RSpec.describe Checkout do
  let(:checkout) { Checkout.new(prices: pricing_rules, discounts: discount_database) }
  let(:pricing_rules) do
    {
      apple: 10,
      orange: 20,
      pear: 15,
      banana: 30,
      pineapple: 100,
      mango: 200
    }
  end

  let(:discount_database) do
    {
      apple: :buy_two_get_one_free,
      pear: :buy_two_get_one_free,
      mango: :buy_three_get_one_free,
      banana: :half_price,
      pineapple: :half_price_off_first
    }
  end

  describe '#total' do
    subject(:total) { checkout.total }

    context 'when no offers apply' do
      before do
        checkout.scan(:apple)
        checkout.scan(:orange)
      end

      it 'returns the base price for the basket' do
        expect(total).to eq(30)
      end
    end

    context 'when a two for 1 applies on apples' do
      before do
        checkout.scan(:apple)
        checkout.scan(:apple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(10)
      end

      context 'and there are other items' do
        before do
          checkout.scan(:orange)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a two for 1 applies on pears' do
      before do
        checkout.scan(:pear)
        checkout.scan(:pear)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end

      context 'and there are other discounted items' do
        before do
          checkout.scan(:banana)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a half price offer applies on bananas' do
      before do
        checkout.scan(:banana)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end
    end

    context 'when a half price offer applies on pineapples restricted to 1 per customer' do
      before do
        checkout.scan(:pineapple)
        checkout.scan(:pineapple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(150)
      end
    end

    context 'when a buy 3 get 1 free offer applies to mangos' do
      before do
        4.times { checkout.scan(:mango) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(600)
      end
    end
  end

  describe '#calculate_discount' do
    subject(:calculate_discount) { checkout.send(:calculate_discount, item, count, price)}

    context 'when no offers apply' do
      let(:item) { :apple }
      let(:count) { 1 }
      let(:price) { pricing_rules[item]}

      it 'returns the base price for the basket' do
        expect(calculate_discount).to eq(0)
      end
    end

    context 'when a half price offer applies on pineapples restricted to 1 per customer' do
      let(:item) { :pineapple }
      let(:count) { 2 }
      let(:price) { pricing_rules[item]}


      it 'returns the discounted price for the basket' do
        expect(calculate_discount).to eq(50)
      end
    end

    context 'when a half price offer applies on bananas' do
      let(:item) { :banana }
      let(:count) { 2 }
      let(:price) { pricing_rules[item]}


      it 'returns the discounted price for the basket' do
        expect(calculate_discount).to eq(30)
      end
    end

    context 'when a two for 1 applies on apples' do
      let(:item) { :apple }
      let(:count) { 2 }
      let(:price) { pricing_rules[item]}


      it 'returns the discounted price for the basket' do
        expect(calculate_discount).to eq(10)
      end
    end

    context 'when a two for 1 applies on pears' do
      let(:item) { :pear }
      let(:count) { 2 }
      let(:price) { pricing_rules[item]}


      it 'returns the discounted price for the basket' do
        expect(calculate_discount).to eq(15)
      end
    end

    context 'when a three for 1 applies on pears' do
      let(:item) { :mango }
      let(:count) { 7 }
      let(:price) { pricing_rules[item]}


      it 'returns the discounted price for the basket' do
        expect(calculate_discount).to eq(400)
      end
    end
  end
end
