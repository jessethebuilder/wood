json.id store.to_param
json.extract! store, :name
json.user_id store.user_id.to_s
