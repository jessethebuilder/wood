class WoodApiOrdersController < WoodApiController
  before_action :set_order, only: [:show, :update, :destroy]

  def create
    @order = Order.create(order_params)
    render template: api_template('orders/show'), status: order_status
  end

  def update
    @order.update(order_params)
    render template: api_template('orders/show'), status: order_status
  end

  def show
    render template: api_template('orders/show')
  end

  def index
    #TODO Scope by Store
    @orders = Order.all
    render template: api_template('orders/index')
  end

  def destroy
    @order.destroy
    head :no_content
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    # Doesn't make sense from an API standpoint to call param 'order_items_attriubtes'.
    converted_params = params
    converted_params[:order_items_attributes] = params[:order_items]
    converted_params[:transactions_attributes] = params[:transactions]

    converted_params.require(:order).permit(
      :store_id,
      order_items: [
        :product_id, :price
      ],
      transactions: [

      ]
    )
  end

  def order_status
    @order.errors.count > 0 ? 422 : 200
  end
end
