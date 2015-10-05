require "spec_helper"

RSpec.describe PendingOrderCleanupJob, type: :job do
  before do
    allow(SpreeNotifications).to receive(:create).and_return(true)
  end

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

  context "with guest order" do
    it "creates a notification associated with guest_token" do
      order = create(:order_with_line_items, :guest, state: "cart")

      PendingOrderCleanupJob.perform_now(order, order.updated_at.to_i)

      expect(SpreeNotifications).
        to have_received(:create).
          with(
            :warn,
            PendingOrderCleanupJob::WARNING_MESSAGE,
            guest_token: order.guest_token
          )
    end
  end

  context "with registered user order" do
    it "creates a notification associated with user" do
      order = create(:order_with_line_items, state: "cart")

      PendingOrderCleanupJob.perform_now(order, order.updated_at.to_i)

      expect(SpreeNotifications).
        to have_received(:create).
          with(
            :warn,
            PendingOrderCleanupJob::WARNING_MESSAGE,
            user: order.user
          )
    end
  end
end
