json.id store.to_param
json.extract! store, :name
json.user_id store.user_id.to_s

if store.errors.count > 0
  json.errors store.errors
end
