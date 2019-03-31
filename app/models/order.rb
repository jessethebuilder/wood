class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :store

  embeds_many :order_items
  accepts_nested_attributes_for :order_items

  embeds_many :transactions
  accepts_nested_attributes_for :transactions


  def total
    order_items.inject(0){ |sum, oi| sum += oi.price }
  end

  validate :total_is_positive, :includes_transaction

  private

  def total_is_positive
    errors.add(:total, 'must be positive') if total <= 0
  end

  def includes_transaction
    # TODO
    # errors.add(:transaction, 'must be present') if transactions.count < 1
  end
end
