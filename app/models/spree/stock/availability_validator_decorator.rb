module Spree
  module Stock
    AvailabilityValidator.class_eval do
      def item_available?(line_item, quantity)
        Stock::QuantifierWithPending.new(
          line_item.variant,
          line_item.order
        ).can_supply?(quantity)
      end
    end
  end
end
