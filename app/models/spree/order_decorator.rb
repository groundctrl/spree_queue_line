module Spree
  Order.class_eval do
    after_save :enqueue_order_expiring_job

    private

    def enqueue_order_expiring_job
      PendingOrderCleanupJob.
        set(wait: 20.minutes).
        perform_later(self, updated_at.to_i)
    end
  end
end
