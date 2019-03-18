class Store
  include Mongoid::Document

  has_many :products, dependent: :destroy, inverse_of: :store
  has_many :orders, dependent: :destroy

  belongs_to :user

  field :name, type: String
  validates :name, presence: true
end
