class Province < ActiveRecord::Base
  attr_accessible :gst, :hst, :name, :pst

  has_many :customer

  validates :gst, :hst, :pst,  :numericality => {:greater_than => 0, :less_than => 1}
end
