module Spree
  module Stock
    class QuantifierWithPending < Quantifier
      def initialize(variant, current_order = nil)
        super(variant)
        @current_order = current_order
      end

      def total_on_hand
        [super - total_pending, 0].max
      end

      private

      def total_pending
        Spree::Order.
          incomplete.
          joins(:line_items).
          where(Spree::LineItem.table_name => { variant_id: @variant }).
          where.not(Spree::Order.table_name => { id: @current_order }).
          sum(:quantity)
      end
    end
  end
end
