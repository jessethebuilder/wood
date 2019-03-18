json.id order_item.to_param
json.extract! order_item, :price
json.product_id order_item.product_id.to_s
