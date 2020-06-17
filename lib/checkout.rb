class Checkout
  attr_reader :prices, :basket
  private :prices, :basket

  def initialize(prices)
    @prices = prices
    @basket = Array.new
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = 0

    basket_tally = basket.tally

    basket_tally.each do |item, count|
      total += prices.fetch(item) * count
      if [:pineapple, :banana, :apple, :pear].include?(item)
        total -= calculate_discount(item, count)
      end
    end

    total
  end

  def calculate_discount(item, count)
    if item == :pineapple
      discount = (prices.fetch(item) / 2)
    elsif item == :banana
      discount = (prices.fetch(item) / 2) * count
    elsif count.even? && item == :apple || item == :pear
      discount = prices.fetch(item) * (count / 2)
    end
    discount || 0
  end
end
