version = ENV.fetch('WOOD_API_VERSION')
controller_path = "#{Rails.root}/app/controllers/api/#{version}/"

require "#{controller_path}wood_api_controller.rb"

Dir["#{controller_path}*.rb"].each do |file|
  require file
end

def wood_api_routes
  scope format: true, constraints: {format: :json} do
    resources :stores, except: [:edit, :new], controller: 'wood_api_stores'
    resources :products, except: [:edit, :new], controller: "wood_api_products"
    resources :orders, except: [:edit, :new], controller: "wood_api_orders"
  end
end
