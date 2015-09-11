module CheckoutHelpers
  def self.included(klass)
    klass.let!(:product) { create(:product_in_stock) }
    klass.let!(:shipping_method) { create(:shipping_method) }
    klass.let!(:payment_method) { create(:check_payment_method) }
    klass.let!(:store) { create(:store) }

    klass.before do
      shipping_method.calculator.update!(preferred_amount: 10)
      product.shipping_category = shipping_method.shipping_categories.first
      product.master.stock_items.first.update!(backorderable: false)
      product.save!
    end
  end

  def fill_in_guest_checkout_details
    within "#guest_checkout" do
      fill_in Spree.t(:email), with: "customer@example.com"
      click_button Spree.t(:continue)
    end
  end

  def fill_in_billing_information
    within "#billing" do
      fill_in Spree.t(:first_name), with: "John"
      fill_in Spree.t(:last_name), with: "Doe"
      fill_in Spree.t(:street_address), with: "123 Some Street"
      fill_in Spree.t(:city), with: "Montgomery"
      fill_in Spree.t(:zip), with: "36101"
      select Spree::State.first.name
      fill_in Spree.t(:phone), with: "123-456-7890"
    end

    click_button Spree.t(:save_and_continue)
  end

  def select_shipping_method
    choose shipping_method.name
    click_button Spree.t(:save_and_continue)
  end

  def select_payment_method
    choose payment_method.name
    click_button Spree.t(:save_and_continue)
  end
end
