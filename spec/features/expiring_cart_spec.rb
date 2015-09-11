require "spec_helper"

RSpec.describe "Expiring cart" do
  include CheckoutHelpers
  include ActiveSupport::Testing::TimeHelpers

  scenario "removes item from customer's cart after 20 minutes" do
    visit spree.root_path
    click_on product.name
    click_button Spree.t(:add_to_cart)

    travel_to 21.minutes.from_now do
      perform_enqueued_jobs

      visit spree.cart_path
      expect(page).to have_no_content(product.name)
    end
  end

  scenario "does not remove items from completed order", :js do
    visit spree.root_path
    click_on product.name
    click_button Spree.t(:add_to_cart)
    click_button Spree.t(:checkout)
    fill_in_guest_checkout_details
    fill_in_billing_information
    select_shipping_method
    select_payment_method

    expect(page).to have_content Spree.t(:order_processed_successfully)

    travel_to 21.minutes.from_now do
      perform_enqueued_jobs

      visit current_path
      expect(page).to have_content(product.name)
    end
  end

  def perform_enqueued_jobs
    ActiveJob::Base.queue_adapter.enqueued_jobs.each do |payload|
      if payload[:at].nil? || Time.current.to_f >= payload[:at]
        payload[:job].
          new(*ActiveJob::Arguments.deserialize(payload[:args])).
          perform_now
      end
    end
  end
end
