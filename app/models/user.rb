class User
  include Mongoid::Document

  has_many :stores
end
