json.id product.to_param
json.extract! product, :name, :description, :price
json.store_id product.store.to_param

if product.errors.count > 0
  json.errors product.errors
end
