class Province < ActiveRecord::Base
  attr_accessible :gst, :hst, :name, :pst

  has_many :customer

  validates :gst, :hst, :pst,  :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 0.99}
  validates :name, :uniqueness => true
  validates :name, :presence => true
end
