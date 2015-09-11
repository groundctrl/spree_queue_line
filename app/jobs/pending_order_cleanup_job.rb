class PendingOrderCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(order, timestamp)
    if order.updated_at.to_i == timestamp && !order.completed?
      order.empty!
    end
  end
end
