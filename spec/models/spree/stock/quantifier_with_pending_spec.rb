require "spec_helper"

RSpec.describe Spree::Stock::QuantifierWithPending do
  let(:product) { create(:product_in_stock) }
  let(:variant) { product.master }

  before do
    variant.stock_items.first.set_count_on_hand(10)
  end

  describe "#total_on_hand" do
    context "without giving a pending order" do
      it "returns remaining stock including reservations in customers' cart" do
        create_pending_order(quantity: 1)
        create_pending_order(quantity: 2)
        quantifier = Spree::Stock::QuantifierWithPending.new(variant)

        expect(quantifier.total_on_hand).to eq 7
      end

      it "does not return negative number" do
        create_pending_order(quantity: 11)
        quantifier = Spree::Stock::QuantifierWithPending.new(variant)

        expect(quantifier.total_on_hand).to eq 0
      end
    end

    context "with a pending order" do
      it "returns remaining stock with reservation but exclude current order" do
        order = create_pending_order(quantity: 1)
        create_pending_order(quantity: 2)
        quantifier = Spree::Stock::QuantifierWithPending.new(variant, order)

        expect(quantifier.total_on_hand).to eq 8
      end
    end
  end

  def create_pending_order(quantity:)
    create(:order, state: "cart").tap do |order|
      create(:line_item, order: order, product: product, quantity: quantity)
    end
  end
end
