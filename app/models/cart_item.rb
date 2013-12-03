class CartItem < ActiveRecord::Base
  attr_accessible :price, :quantity

  has_one :game
  belongs_to :order

  validates :price, :numericality    => {:greater_than_or_equal_to => 0.01}
  validates :quantity, :numericality => {:only_intger => true}

end
