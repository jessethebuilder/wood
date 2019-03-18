class WoodApiStoresController < WoodApiController
  before_action :set_store, only: [:show, :update, :destroy]

  def create
    @store = Store.new(store_params)
    respond_to do |format|
      if @store.save
        format.json{ render template: api_template('stores/show') }
      else
        format.json{ render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @store.update(store_params)
        format.json{ render template: api_template('stores/show') }
      else
        format.json{ render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.json{ render template: api_template('stores/show') }
    end
  end

  def index
    @stores = Store.all

    respond_to do |format|
      format.json{ render template: api_template('stores/index') }
    end
  end

  def destroy
    @store.destroy
    respond_to { |format| format.json { head :no_content } }
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :user_id)
  end
end
