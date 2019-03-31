require 'rails_helper'

describe 'Order Requests', type: :request do
  before do
    @user = create(:user)
    @store = create(:store, user: @user)
    @order = create(:order, store: @store)
    # @order.order_items << build(:order_item)
    # @order.save!
    @product = create(:product)

    @order_params = {
      order: attributes_for(:order).merge(
        store_id: @store.to_param,
        order_items: [order_item_json(@product)],
        transaction: [attributes_for(:transaction)]
      )
    }
  end

  describe 'POST /orders (Create)' do
    it 'should return success' do
      post '/orders.json', params: @order_params
      response.status.should == 200
    end

    it 'should create an Order' do
      expect{ post '/orders.json', params: @order_params }
            .to change{ Order.count }.by(1)
    end

    it 'should save Order params to new Order' do
      post '/orders.json', params: @order_params

      json = JSON.parse(response.body)
      json['store_id'].should == @store.to_param
    end

    it 'should return new Order as JSON' do
      post '/orders.json', params: @order_params
      response.body.should == json_order_results(assigns[:order])
    end

    specify 'new Order can have many order_items' do
      @order_params[:order][:order_items] << order_item_json
      post '/orders.json', params: @order_params

      assigns[:order].order_items.count.should == 2
    end

    describe 'Errors' do
      it 'should return error status, if prams are not valid' do
        post '/orders.json', params: {order: {name: ''}}
        response.status.should == 422
      end

      it 'should return a hash of errors with order JSON, if any' do
        @order_params[:order][:store_id] = nil
        post '/orders.json', params: @order_params
        response.body.should == {
          "id"=>nil,
          "created_at"=>nil,
          "updated_at"=>nil,
          "store_id"=> @store.to_param,
          "order_items"=>[
            {
              "id"=>nil,
              "price"=> price,
              "product_id"=> @product.to_param,
            }
          ],
          errors: {
            store: ["can't be blank"]
          }
        }.to_json
      end

      it 'should return errors about embedded objects' do
        price = @product.price + 1
        @order_params[:order][:order_items].first[:price] = price # Price must match

        post '/orders.json', params: @order_params
        response.body.should == {
          "id"=>nil,
          "created_at"=>nil,
          "updated_at"=>nil,
          "store_id"=> @store.to_param,
          "order_items"=>[
            {
              "id"=>nil,
              "price"=> @product.price,
              "product_id"=> @product.to_param,
              "errors"=>{
                "price"=>["must match current Product price"]
              }
            }
          ],
          errors: {
            order_items: ['is invalid']
          }
        }.to_json
      end
    end
  end # Create

  describe 'PUT /orders/:id (Update)' do
    it 'should return success' do
      put "/orders/#{@order.to_param}.json", params: @order_params
      response.status.should == 200
    end

    it 'should update a Order' do
      expect{ post '/orders.json', params: @order_params }
            .to change{ Order.count }.by(1)
    end

    it 'should return @order as JSON' do
      put "/orders/#{@order.to_param}.json", params: @order_params
      response.body.should == json_order_results(@order)
    end

    it 'should return error status, if prams are not valid' do
      @order_params[:order][:store_id] = nil

      put "/orders/#{@order.to_param}.json", params: @order_params
      response.status.should == 422
    end

    it 'should be able to add an order item' do
      @order_params[:order][:order_items] << order_item_json
      put "/orders/#{@order.to_param}.json", params: @order_params
      @order.reload.order_items.count.should == 2
    end

    it 'should be able to remove an item' do
      # @order will not save unless there is at least 1 order_item, so create 2,
      # as in the spec above.
      @order_params[:order][:order_items] << order_item_json
      put "/orders/#{@order.to_param}.json", params: @order_params

      @order_params[:order][:order_items].delete_at(0)
      put "/orders/#{@order.to_param}.json", params: @order_params
      @order.reload.order_items.count.should == 1
    end

    it 'should return a hash of errors, if any' do
      @order_params[:order][:store_id] = nil

      put "/orders/#{@order.to_param}.json", params: @order_params

      response.body.should == {
        store: ["can't be blank"]
      }.to_json
    end
  end # Update

  describe 'GET /orders/:id (Show)' do
    it 'should return Order JSON' do
      get "/orders/#{@order.to_param}.json"
      response.body.should == json_order_results(@order)
    end
  end # Show

  describe 'GET /orders/ (Index)' do
    it 'should require a store_id' do
      get '/orders.json'
      response.status.should == 403
      response.body.should == 'store_id param required'
    end

    it 'should return all @store orders as JSON' do
      order2 = create(:order, store: @store)
      other_order = create(:order) # Will not be in returned data

      get "/orders.json?store_id=#{@store.to_param}"

      response.body.should == [
        JSON.parse(json_order_results(@order)),
        JSON.parse(json_order_results(order2))
      ].to_json
    end
  end # Index

  describe 'DELETE /orders/:id (Destroy)' do
    it 'should delete @order' do
      expect{ delete "/orders/#{@order.to_param}.json" }
            .to change{ Order.where(id: @order.id).first }
            .from(@order).to(nil)
    end

    it 'should return no content status' do
      delete "/orders/#{@order.to_param}.json"
      response.status.should == 204
    end
  end # Destroy

#--- Helpers ---------------------------------------------------------------------------

  def order_item_json(product = create(:product))
    # Because order.price has to match  product.price, this is hard /w
    # FactoryBot, so include here.
    attributes_for(:order_item).merge(
      {
        price: product.price,
        product_id: product.to_param
      }
    )
  end

  def json_order_results(order)
    order.reload

    order_items = order.order_items.map do |oi|
      {
        id: oi.to_param,
        price: oi.product.price,
        product_id: oi.product.to_param
      }
    end

    {
      id: order.to_param,
      created_at: order.created_at,
      updated_at: order.updated_at,
      store_id: order.store.to_param,
      order_items: order_items
    }.to_json
  end
end
