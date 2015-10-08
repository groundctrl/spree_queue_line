require "securerandom"

module Spree
  Order.class_eval do
    before_save :set_updated_at_token
    after_save :enqueue_order_expiring_job

    private

    def set_updated_at_token
      self.updated_at_token = SecureRandom.base64
    end

    def enqueue_order_expiring_job
      PendingOrderCleanupJob.
        set(wait: 20.minutes).
        perform_later(self, updated_at_token)
    end
  end
end
