require 'rails_helper'

describe 'Store Requests', type: :request do
  before do
    @user = create(:user)
    @store = create(:store, user: @user)

    @store_params = {
      store: attributes_for(:store).merge(
        user_id: @user.to_param
      )
    }
  end

  describe 'POST /stores (Create)' do
    it 'should return success' do
      post '/stores.json', params: @store_params
      response.status.should == 200
    end

    it 'should create a Store' do
      expect{ post '/stores.json', params: @store_params }
            .to change{ Store.count }.by(1)
    end

    it 'should save store params to new store' do
      post '/stores.json', params: @store_params

      json = JSON.parse(response.body)
      json['name'].should == @store_params[:store][:name]
      json['user_id'].should == @user.to_param
    end

    it 'should return new Store as JSON' do
      post '/stores.json', params: @store_params
      response.body.should == json_store_results(assigns[:store])
    end

    it 'should return error status, if prams are not valid' do
      post '/stores.json', params: {store: {name: ''}}
      response.status.should == 422
    end

    it 'should return a hash of errors, if any' do
      post '/stores.json', params: {store: {name: ''}}
      response.body.should == {
        user: ["can't be blank"],
        name: ["can't be blank"]
      }.to_json
    end
  end # Create

  describe 'PUT /stores/:id (Update)' do
    it 'should return success' do
      put "/stores/#{@store.to_param}.json", params: @store_params
      response.status.should == 200
    end

    it 'should update a Store' do
      expect{ post '/stores.json', params: @store_params }
            .to change{ Store.count }.by(1)
    end

    it 'should return @store as JSON' do
      put "/stores/#{@store.to_param}.json", params: @store_params
      response.body.should == json_store_results(@store)
    end

    it 'should return error status, if prams are not valid' do
      put "/stores/#{@store.to_param}.json", params: {store: {name: ''}}
      response.status.should == 422
    end

    it 'should return a hash of errors, if any' do
      put "/stores/#{@store.to_param}.json", params: {store: {name: ''}}
      response.body.should == {
        name: ["can't be blank"]
      }.to_json
    end
  end # Update

  describe 'GET /stores/:id (Show)' do
    it 'should return store JSON' do
      get "/stores/#{@store.to_param}.json"
      response.body.should == json_store_results(@store)
    end
  end # Show

  describe 'GET /stores (Index)' do
    it 'should return all stores as JSON' do
      store2 = create(:store)

      get '/stores.json'

      response.body.should == [
        JSON.parse(json_store_results(@store)),
        JSON.parse(json_store_results(store2))
      ].to_json
    end
  end # Index

  describe 'DELETE /stores/:id (Destroy)' do
    it 'should delete @store' do
      expect{ delete "/stores/#{@store.to_param}.json" }
            .to change{ Store.where(id: @store.id).first }
            .from(@store).to(nil)
    end

    it 'should return no content status' do
      delete "/stores/#{@store.to_param}.json"
      response.status.should == 204
    end
  end # Destroy

#--- Helpers ---------------------------------------------------------------------------

  def json_store_results(store)
    store.reload

    {
      id: store.to_param,
      name: store.name,
      user_id: store.user.to_param
    }.to_json
  end
end
