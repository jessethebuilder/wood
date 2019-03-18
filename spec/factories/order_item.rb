FactoryBot.define do
  factory :order_item do
    order
    product_id { create(:product).to_param }

    after(:build) do |order_item|
      # order_item.price MUST match product.price
      order_item.price = order_item.product.price
    end
  end
end
