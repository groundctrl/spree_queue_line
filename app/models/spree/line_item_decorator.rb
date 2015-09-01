module Spree
  LineItem.class_eval do
    def sufficient_stock?
      Stock::QuantifierWithPending.new(variant, order).can_supply? quantity
    end
  end
end
