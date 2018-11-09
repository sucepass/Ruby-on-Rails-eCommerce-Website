class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  # belongs_to :order

  # LOGIC
  def total_price
    if valid_quantity_and_price?
      quantity.to_s.to_d * product.price.to_s.to_d
    else
      0.0
    end
  end

  def valid_quantity_and_price?
    !quantity.to_s.strip.empty? && !product.price.to_s.strip.empty?
  end
end
