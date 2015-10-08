require "spec_helper"

RSpec.describe Spree::Order do
  it "enqueues PendingOrderCleanupJob when order is created" do
    job = spy(:job)
    allow(PendingOrderCleanupJob).to receive(:set).and_return(job)

    order = create(:order, state: "cart")

    expect(PendingOrderCleanupJob).to have_received(:set).with(wait: 20.minutes)
    expect(job).
      to have_received(:perform_later).with(order, order.updated_at_token)
  end

  it "enqueues PendingOrderCleanupJob when order is updated" do
    order = create(:order, state: "cart")
    job = spy(:job)
    allow(PendingOrderCleanupJob).to receive(:set).and_return(job)

    order.save!

    expect(PendingOrderCleanupJob).to have_received(:set).with(wait: 20.minutes)
    expect(job).
      to have_received(:perform_later).with(order, order.updated_at_token)
  end

  it "sets updated_at_token when the job is created or updated" do
    order = create(:order)

    expect(order.updated_at_token).not_to be_nil

    previous_token = order.updated_at_token
    order.save!

    expect(order.updated_at_token).not_to eq previous_token
  end
end
