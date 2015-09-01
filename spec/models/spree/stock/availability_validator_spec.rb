require "spec_helper"

RSpec.describe Spree::Stock::AvailabilityValidator do
  describe "#item_available?" do
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
      line_item = build(:line_item, variant: variant, order: order)
      validator = Spree::Stock::AvailabilityValidator.new

      result = validator.item_available?(line_item, 1)

      expect(result).to eq can_supply_result
      expect(Spree::Stock::QuantifierWithPending).
        to have_received(:new).with(variant, order)
      expect(quantifier).to have_received(:can_supply?).with(1)
    end
  end
end
