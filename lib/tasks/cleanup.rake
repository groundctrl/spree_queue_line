require "spree_queue_line/orders_cleaner"

namespace :spree do
  desc "Remove stale empty orders from the database"
  task remove_stale_orders: :environment do
    SpreeQueueLine::OrdersCleaner.perform
  end
end
