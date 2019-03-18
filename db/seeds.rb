User.destroy_all
Store.destroy_all

u = User.create!
s = Store.new(name: 'Super Store')
s.user = u
s.save!

10.times do
  s.products << Product.new(
    name: Faker::Lorem.word,
    description: Faker::Lorem.sentence,
    price: Random.rand(0.01..1000)
  )
end

o = Order.new
o.store = s

5.times do
  p = Product.all.sample
  oi = OrderItem.new(
    price: p.price,
  )

  oi.product = p

  o.order_items  << oi

  o.save!
  oi.save!
end
