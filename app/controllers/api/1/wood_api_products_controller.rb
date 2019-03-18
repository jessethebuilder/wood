class WoodApiProductsController < WoodApiController
  before_action :set_product, only: [:update, :show, :destroy]

  def create
    @product = Product.new(product_params)

    if @product.save
      render template: api_template('products/show')
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render template: api_template('products/show')
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def show
    render template: api_template('products/show')
  end

  def index
    # TODO scope by Store
    @products = Product.all
    render template: api_template('products/index')
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
end
