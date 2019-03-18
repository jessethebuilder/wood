require 'rails_helper'

describe User, type: :model do
  describe 'Associations' do
    it{ should have_many :stores}
  end
end
