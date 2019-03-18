FactoryBot.define do
  factory :order do
    store

    before(:build, :create) do |order|
      order.order_items << FactoryBot.build(:order_item) # at least 1 OrderItem must exist (or total == 0)
      order.transactions << FactoryBot.build(:transaction) # at least 1 Transaction must exist.
    end
  end
end
