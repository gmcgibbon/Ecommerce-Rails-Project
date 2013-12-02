class PaymentMethod < ActiveRecord::Base
  attr_accessible :name

  belongs_to :customer

  validates :name, uniqueness: true
  validates :name, presence: true
end
