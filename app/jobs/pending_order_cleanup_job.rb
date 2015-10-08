class PendingOrderCleanupJob < ActiveJob::Base
  WARNING_MESSAGE = "Your cart has been emptied due to an inactivity."

  queue_as :default

  def perform(order, verification_token)
    if order_unchanged?(order, verification_token) && !order.completed?
      order.transaction do
        order.empty!
        SpreeNotifications.create :warn, WARNING_MESSAGE, recipient_for(order)
      end
    end
  end

  private

  def order_unchanged?(order, verification_token)
    order.updated_at_token == verification_token
  end

  def recipient_for(order)
    if order.user
      { user: order.user }
    else
      { guest_token: order.guest_token }
    end
  end
end
