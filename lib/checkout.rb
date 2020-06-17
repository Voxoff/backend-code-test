class Checkout
  attr_reader :prices, :basket
  private :prices, :basket

  def initialize(prices)
    @prices = prices
    @basket = []
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = 0

    basket.tally.each do |item, count|
      price = prices.fetch(item)
      total += price * count
      if [:pineapple, :banana, :apple, :pear, :mango].include?(item)
        total -= calculate_discount(item, count, price)
      end
    end

    total
  end

  private

  def calculate_discount(item, count, price)
    if item == :pineapple
      discount = price / 2
    elsif item == :banana
      discount = (price / 2) * count
    elsif count.even? && item == :apple || item == :pear
      discount = price * (count / 2)
    elsif item == :mango && count >= 3
      discount = price * (count / 3)
    end
    discount || 0
  end
end
