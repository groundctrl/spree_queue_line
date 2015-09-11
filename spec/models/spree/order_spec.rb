require "spec_helper"

RSpec.describe Spree::Order do
  it "enqueues PendingOrderCleanupJob when order is created" do
    job = spy(:job)
    allow(PendingOrderCleanupJob).to receive(:set).and_return(job)

    order = create(:order, state: "cart")

    expect(PendingOrderCleanupJob).to have_received(:set).with(wait: 20.minutes)
    expect(job).
      to have_received(:perform_later).with(order, order.updated_at.to_i)
  end

  it "enqueues PendingOrderCleanupJob when order is updated" do
    order = create(:order, state: "cart")
    job = spy(:job)
    allow(PendingOrderCleanupJob).to receive(:set).and_return(job)

    order.save!

    expect(PendingOrderCleanupJob).to have_received(:set).with(wait: 20.minutes)
    expect(job).
      to have_received(:perform_later).with(order, order.updated_at.to_i)
  end
end
