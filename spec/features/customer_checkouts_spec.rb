require "spec_helper"

RSpec.feature "Customer checkouts" do
  include CheckoutHelpers

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

  scenario "adding item to cart reserves the item" do
    order = create(:order, state: "cart")
    create(:line_item, order: order, product: product, quantity: 10)

    visit spree.root_path
    click_on product.name
    expect(page).to have_content("Out of Stock")

    click_button "Add To Cart"

    expect(page).to have_content("not available")
  end

  scenario "adjusting quantity in cart takes reservation into account" do
    order = create(:order, state: "cart")
    create(:line_item, order: order, product: product, quantity: 9)

    visit spree.root_path
    click_on product.name
    click_button "Add To Cart"
    fill_in line_item_quantity_field, with: "2"
    click_button "Update"

    expect(page).to have_content("not available")
  end

  def line_item_quantity_field
    find(".line-item:first .cart-item-quantity input")["id"]
  end
end
