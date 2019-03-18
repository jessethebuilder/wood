require 'rails_helper'

describe OrderItem, type: :model do
  before do
    @order_item = build(:order_item)
  end

  describe 'Associations' do
    it{ should belong_to :product }
    it{ should be_embedded_in :order }
  end

  describe 'Validations' do
    it{ should validate_presence_of :price }
    it{ should validate_numericality_of(:price).greater_than(0) }

    it 'should invalidate on :price, if price does not match :product.price' do
      @order_item.save! # :product.price is saved to :price
      @order_item.update(price: @order_item.price + 1)
      @order_item.valid?.should == false
      @order_item.errors[:price].include?('must match current Product price')
                 .should == true
    end
  end # Validations

  describe 'Attributes' do

  end # Attributes
end
