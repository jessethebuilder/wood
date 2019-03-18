require 'rails_helper'

describe Transaction, type: :model do
  describe 'Associations' do
    it{ should be_embedded_in :order }
  end
end
