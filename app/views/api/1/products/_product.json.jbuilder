json.id product.to_param
json.extract! product, :name, :description, :price
json.store_id product.store.to_param
