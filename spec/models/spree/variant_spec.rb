require "spec_helper"

RSpec.describe Spree::Variant do
  describe "#can_supply?" do
    it "uses Stock::QuantifierWithPending" do
      quantifier = instance_double(
        Spree::Stock::QuantifierWithPending,
        can_supply?: true
      )
      allow(Spree::Stock::QuantifierWithPending).
        to receive(:new).and_return(quantifier)
      variant = build(:variant)

      variant.can_supply?(1)

      expect(Spree::Stock::QuantifierWithPending).
        to have_received(:new).with(variant)
      expect(quantifier).to have_received(:can_supply?).with(1)
    end
  end

  describe "#total_on_hand" do
    it "uses Stock::QuantifierWithPending" do
      quantifier = instance_double(
        Spree::Stock::QuantifierWithPending,
        total_on_hand: 10
      )
      allow(Spree::Stock::QuantifierWithPending).
        to receive(:new).and_return(quantifier)
      variant = build(:variant)

      expect(variant.total_on_hand).to eq 10
      expect(Spree::Stock::QuantifierWithPending).
        to have_received(:new).with(variant)
      expect(quantifier).to have_received(:total_on_hand)
    end
  end
end
