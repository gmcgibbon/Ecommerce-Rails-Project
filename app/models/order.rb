class Order < ActiveRecord::Base
  attr_accessible :gst, :hst, :pst, :status, :payment_method_id, :customer_id

  has_many :cart_items
  belongs_to :customer

  validates :gst, :hst, :pst,  :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 0.99}
  validates :status, :presence => true

  def display_name
  	"Order #{self[:id]}"
  end
end
