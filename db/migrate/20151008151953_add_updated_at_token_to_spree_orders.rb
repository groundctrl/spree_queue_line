class AddUpdatedAtTokenToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :updated_at_token, :string
  end
end
