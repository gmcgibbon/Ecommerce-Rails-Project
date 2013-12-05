class CartItem < ActiveRecord::Base
  attr_accessible :price, :quantity, :game_id

  belongs_to :order

  validates :price, :numericality    => {:greater_than_or_equal_to => 0.01}
  validates :quantity, :numericality => {:only_intger => true}

  def display_name
  	"Item #{self[:id]} x #{self[:quantity]}"
  end

end
