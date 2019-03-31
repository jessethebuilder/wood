class WoodApiOrdersController < WoodApiController
  # before_action :set_order, only: [:show, :update, :destroy]
  before_action :set_order, only: [:show]

  def create
    @order = Order.new(order_params)

    if @order.save
      render template: api_template('orders/show')
    else
      #TODO render more complex JSON here, showing assoc. errors
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      render template: api_template('orders/show')
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def show
    render template: api_template('orders/show')
  end

  def index
    #TODO Scope by Store
    @orders = Order.all
    render template: api_template('orders/index')
  end

  # def destroy
  #   @order.destroy
  #   head :no_content
  # end

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
end
