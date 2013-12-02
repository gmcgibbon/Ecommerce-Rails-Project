class Province < ActiveRecord::Base
  attr_accessible :gst, :hst, :name, :pst

  has_many :customer

  validates :name, :uniqueness => true
  validates :name, :presence => true
end
