require 'rails_helper'

describe 'Product Requests', type: :request do
  before do
    @store = create(:store)
    @product = create(:product, store: @store)

    @product_params = {
      product: attributes_for(:product).merge(
        store_id: @store.to_param
      )
    }
  end

  describe 'POST /products (Create)' do
    it 'should return success' do
      post '/products.json', params: @product_params
      response.status.should == 200
    end

    it 'should create a Product' do
      expect{ post '/products.json', params: @product_params }
            .to change{ Product.count }.by(1)
    end


    it 'should save store params to new store' do
      post '/products.json', params: @product_params

      json = JSON.parse(response.body)
      json['name'].should == @product_params[:product][:name]
    end

    it 'should return new Product as JSON' do
      post '/products.json', params: @product_params
      response.body.should == json_product_results(assigns[:product])
    end

    it 'should return error status, if prams are not valid' do
      post '/products.json', params: {product: {name: ''}}
      response.status.should == 422
    end

    it 'should return a hash of errors, if any' do
      post '/products.json', params: {product: {name: ''}}
      response.body.should == {
        store: ["can't be blank"],
        name: ["can't be blank"],
        price: ["can't be blank", "is not a number"]
      }.to_json
    end
  end # Create

  describe 'PUT /products/:id (Update)' do
    it 'should return success' do
      put "/products/#{@product.to_param}.json", params: @product_params
      response.status.should == 200
    end

    it 'should update a Product' do
      expect{ post '/products.json', params: @product_params }
            .to change{ Product.count }.by(1)
    end

    it 'should return @product as JSON' do
      put "/products/#{@product.to_param}.json", params: @product_params
      response.body.should == json_product_results(@product)
    end

    it 'should return error status, if prams are not valid' do
      put "/products/#{@product.to_param}.json", params: {product: {name: ''}}
      response.status.should == 422
    end

    it 'should return a hash of errors, if any' do
      put "/products/#{@product.to_param}.json", params: {product: {name: ''}}
      response.body.should == {
        name: ["can't be blank"]
      }.to_json
    end
  end # Update

  describe 'GET /products/:id (Show)' do
    it 'should return store JSON' do
      get "/products/#{@product.to_param}.json"
      response.body.should == json_product_results(@product)
    end
  end # Show

  describe 'GET /products (Index)' do
    it 'should return all stores as JSON' do
      product2 = create(:product)

      get '/products.json'

      response.body.should == [
        JSON.parse(json_product_results(@product)),
        JSON.parse(json_product_results(product2))
      ].to_json
    end
  end # Index

  describe 'DELETE /products/:id (Destroy)' do
    it 'should delete @product' do
      expect{ delete "/products/#{@product.to_param}.json" }
            .to change{ Product.where(id: @product.id).first }
            .from(@product).to(nil)
    end
  
    it 'should return no content status' do
      delete "/products/#{@product.to_param}.json"
      response.status.should == 204
    end
  end # Destroy

#--- Helpers ---------------------------------------------------------------------------

  def json_product_results(product)
    product.reload

    {
      id: product.id.to_param,
      name: product.name,
      description: nil,
      price: product.price,
      store_id: product.store.to_param
    }.to_json
  end
end
