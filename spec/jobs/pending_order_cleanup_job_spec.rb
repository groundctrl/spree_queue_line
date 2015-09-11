require "spec_helper"

RSpec.describe PendingOrderCleanupJob, type: :job do
  it "clear items from order" do
    order = create(:order_with_line_items, state: "cart")

    PendingOrderCleanupJob.perform_now(order, order.updated_at.to_i)

    expect(order.reload.line_items).to be_empty
  end

  it "does not clear items if timestamp does not match" do
    order = create(:order_with_line_items, state: "cart")

    PendingOrderCleanupJob.perform_now(order, 20.minutes.ago.to_i)

    expect(order.reload.line_items).not_to be_empty
  end

  it "does not clear items if order is completed" do
    order = create(:completed_order_with_totals, state: "complete")

    PendingOrderCleanupJob.perform_now(order, order.updated_at.to_i)

    expect(order.reload.line_items).not_to be_empty
  end
end
