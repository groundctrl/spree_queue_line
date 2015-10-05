class PendingOrderCleanupJob < ActiveJob::Base
  WARNING_MESSAGE = "Your cart has been emptied due to an inactivity."

  queue_as :default

  def perform(order, timestamp_at_queued)
    if order_unchanged?(order, timestamp_at_queued) && !order.completed?
      order.transaction do
        order.empty!
        SpreeNotifications.create :warn, WARNING_MESSAGE, recipient_for(order)
      end
    end
  end

  private

  def order_unchanged?(order, timestamp_at_queued)
    order.updated_at.to_i == timestamp_at_queued
  end

  def recipient_for(order)
    if order.user
      { user: order.user }
    else
      { guest_token: order.guest_token }
    end
  end
end
