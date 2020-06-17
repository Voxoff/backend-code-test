require_relative './discount'

class Checkout
  attr_reader :prices, :basket, :discounts
  private :prices, :basket, :discounts

  def initialize(prices:, discounts:)
    @prices = prices
    @basket = []
    @discounts = Discount.new(discounts: discounts)
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = 0

    basket.tally.each do |item, count|
      price = prices.fetch(item)
      total += price * count
      total -= calculate_discount(item, count, price)
    end

    total
  end

  private

  def calculate_discount(item, count, price)
    discount_type = @discounts.find_by_item(item)

    if discount_type == :half_price_off_first
      discount = price / 2
    elsif discount_type == :half_price
      discount = (price / 2) * count
    elsif discount_type == :buy_two_get_one_free
      discount = price * (count / 2)
    elsif discount_type == :buy_three_get_one_free
      discount = price * (count / 3)
    end
    discount || 0
  end
end
