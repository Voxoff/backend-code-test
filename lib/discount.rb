class Discount
  # { apple: :buy_two_get_one_free,
  #   pear: :buy_two_get_one_free,
  #   mango: :buy_three_get_one_free,
  #   banana: :half_price,
  #   pineapple: :half_price_off_first
  # }

  def initialize(discounts:)
    @discounts = discounts
  end

  def find_by_item(item)
    @discounts[item]
  end
end
