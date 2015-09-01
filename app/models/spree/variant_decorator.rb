module Spree
  Variant.class_eval do
    def can_supply?(quantity = 1)
      Spree::Stock::QuantifierWithPending.new(self).can_supply?(quantity)
    end

    def total_on_hand
      Spree::Stock::QuantifierWithPending.new(self).total_on_hand
    end
  end
end
