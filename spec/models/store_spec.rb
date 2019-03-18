require 'rails_helper'

describe Store, type: :model do
  before do
    @store = build(:store)
  end

  describe 'Associations' do
    it{ should have_many :products }
    
    it 'should destroy :products when Store is destoryed' do
      product = create(:product)
      @store.products << product

      @store.save!

      expect{ @store.destroy }
            .to change{ Product.where(id: product.id).first }
            .from(product).to(nil)
    end

    it 'should destroy :orders when Store is destoryed' do
      order = create(:order)

      @store.orders << order

      @store.save!

      expect{ @store.destroy }
            .to change{ Order.where(id: order.id).first }
            .from(order).to(nil)
    end

    it{ should have_many :orders }
    it{ should belong_to :user}
  end

  describe 'Validations' do
    it{ should validate_presence_of :name }
  end
end
