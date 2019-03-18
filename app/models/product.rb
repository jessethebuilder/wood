class Product
  include Mongoid::Document

  belongs_to :store, inverse_of: :products

  # has_many :order_items

  field :name, type: String
  validates :name, presence: true

  field :price, type: Float
  validates :price, presence: true, numericality: {greater_than: 0}

  field :description, type: String
end
