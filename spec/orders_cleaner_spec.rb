require "spec_helper"
require "spree_queue_line/orders_cleaner"

RSpec.describe SpreeQueueLine::OrdersCleaner do
  describe ".perform" do
    it "Remove empty orders that are not completed 24 hours ago" do
      _old_empty_order = create(:order, created_at: 1.day.ago)
      non_empty_order = create(:order_with_line_items, created_at: 1.day.ago)
      new_empty_order = create(:order)

      SpreeQueueLine::OrdersCleaner.perform

      expect(Spree::Order.order(:id).all).
        to eq [non_empty_order, new_empty_order]
    end
  end
end
