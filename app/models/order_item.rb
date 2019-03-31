class OrderItem
  include Mongoid::Document

  embedded_in :order

  belongs_to :product

  field :price, type: Float
  validates :price, presence: true,  numericality: {greater_than: 0}

  validate :price_matches_product_price

  private

  def price_matches_product_price
    unless product && product.price == self.price
      self.errors.add(:price, 'must match current Product price')
    end
  end
end
