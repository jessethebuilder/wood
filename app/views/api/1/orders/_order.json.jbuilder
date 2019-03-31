json.id order.to_param
json.extract! order, :created_at, :updated_at

json.store_id order.store_id.to_s

json.order_items do
  json.array! order.order_items do |order_item|
    json.partial! api_template('order_items/order_item'),
                  order_item: order_item
  end
end

if order.errors.count > 0
  json.errors order.errors
end
