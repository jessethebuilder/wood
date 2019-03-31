class WoodApiProductsController < WoodApiController
  before_action :set_product, only: [:update, :show, :destroy]

  def create
    @product = Product.create(product_params)
    render template: api_template('products/show'), status: product_status
  end

  def update
    @product.update(product_params)
    render template: api_template('products/show'), status: product_status
  end

  def show
    render template: api_template('products/show')
  end

  def index
    @store = Store.where(id: params[:store_id]).first

    if @store # must be provided.
      render json: 'store_id param required', status: 403
    else
      @products = Product.all
      render template: api_template('products/index')
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :store_id
    )
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_status
    @product.errors.count > 0 ? 422 : 200
  end
end
