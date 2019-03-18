require 'rails_helper'

describe Product, type: :model do
  describe 'Validations' do
    it{ should validate_presence_of :name }

    it{ should validate_presence_of :price }
    it{ should validate_numericality_of(:price).greater_than(0) }
  end

  describe 'Associatiions' do
    it{ should belong_to :store }
    # it{ should have_many :order_items }
  end
end
