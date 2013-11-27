class Order < ActiveRecord::Base
  attr_accessible :gst, :hst, :pst, :status

  has_many :cart_item

  validates :gst, :hst, :pst,  :numericality => {:greater_than => 0, :less_than => 1}
  validates :status, :presence => true
end
