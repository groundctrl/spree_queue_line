require "spec_helper"

RSpec.feature "Customer checkouts" do
  let!(:product) { create(:product_in_stock) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:payment_method) { create(:check_payment_method) }
  let!(:store) { create(:store) }

  before do
    shipping_method.calculator.update!(preferred_amount: 10)
    product.shipping_category = shipping_method.shipping_categories.first
    product.save!
  end

  scenario "proceed successfully", :js do
    visit spree.root_path
    click_on product.name
    click_button "Add To Cart"
    click_button "Checkout"
    fill_in_guest_checkout_details
    fill_in_billing_information
    select_shipping_method
    select_payment_method

    expect(page).to have_content("Your order has been processed successfully")
  end

  def fill_in_guest_checkout_details
    within "#guest_checkout" do
      fill_in "Email", with: "customer@example.com"
      click_button "Continue"
    end
  end

  def fill_in_billing_information
    within "#billing" do
      fill_in "First Name", with: "John"
      fill_in "Last Name", with: "Doe"
      fill_in "Street Address", with: "123 Some Street"
      fill_in "City", with: "Montgomery"
      fill_in "Zip", with: "36101"
      select "Alabama"
      fill_in "Phone", with: "123-456-7890"
    end

    click_button "Save and Continue"
  end

  def select_shipping_method
    choose shipping_method.name
    click_button "Save and Continue"
  end

  def select_payment_method
    choose payment_method.name
    click_button "Save and Continue"
  end
end
