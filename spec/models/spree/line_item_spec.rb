require "spec_helper"

RSpec.describe Spree::LineItem do
  describe "#sufficient_stock?" do
    it "uses Stock::QuantifierWithPending" do
      variant = build_stubbed(:variant)
      order = build_stubbed(:order)
      can_supply_result = Object.new
      quantifier = instance_double(
        Spree::Stock::QuantifierWithPending,
        can_supply?: can_supply_result
      )
      allow(Spree::Stock::QuantifierWithPending).
        to receive(:new).and_return(quantifier)
      line_item = build(:line_item, variant: variant, order: order, quantity: 1)

      result = line_item.sufficient_stock?

      expect(result).to eq can_supply_result
      expect(Spree::Stock::QuantifierWithPending).
        to have_received(:new).with(variant, order)
      expect(quantifier).to have_received(:can_supply?).with(1)
    end
  end
end
