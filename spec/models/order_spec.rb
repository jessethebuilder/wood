require 'rails_helper'

describe Order, type: :model do
  before do
    @order = build(:order)
  end

  describe 'Associations' do
    it{ should belong_to :store }

    it{ should embed_many :transactions }
    it{ should embed_many :order_items}
  end

  describe 'Validations' do
    specify 'Total must be positive' do
      @order.order_items = []
      @order.valid?.should == false
      @order.errors[:total].include?('must be positive').should == true
    end

    describe 'Error Messages' do
      it 'should forward specific messages about associated errors' do
        oi = build(:order_item)
        oi.price += 1 # invalid, because it is not the same as oi.product.price
        @order.order_items << oi
        @order.valid?.should == false
        @order.errors[:order_items].should == ['is invalid', '']
      end
    end
  end # Validations

  describe 'Methods' do
    specify '#total should equal total of order_items' do
      item1 = build(:order_item)
      item2 = build(:order_item)

      @order.order_items << [item1, item2]
      @order.total.should == item1.price + item2.price
    end
  end # Methods
end
