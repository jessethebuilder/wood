class WoodApiStoresController < WoodApiController
  before_action :set_store, only: [:show, :update, :destroy]

  def create
    @store = Store.create(store_params)
    render template: api_template('stores/show'), status: store_status
  end

  def update
    @store.update(store_params)
    render template: api_template('stores/show'), status: store_status
  end

  def show
    render template: api_template('stores/show')
  end

  def index
    @stores = Store.all
    render template: api_template('stores/index')
  end

  def destroy
    @store.destroy
    head :no_content
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :user_id)
  end

  def store_status
    @store.errors.count > 0 ? 422 : 200
  end
end
