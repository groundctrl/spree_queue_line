module SpreeQueueLine
  class OrdersCleaner
    def self.perform
      new.perform
    end

    def perform
      Spree::Order.
        incomplete.
        where("created_at < ?", 1.day.ago).
        where(item_count: 0).
        destroy_all
    end
  end
end
