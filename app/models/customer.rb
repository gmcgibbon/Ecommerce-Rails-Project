class Customer < ActiveRecord::Base
  attr_accessible :address, :city, :country, :email, :first_name, :last_name, :postal_code, :province_id

  belongs_to :province

  validates :address,        :format => {:with => /^[0-9]+ +\w+ +\w+?\S$/, :message => "was not recognized. eg. 123 Blue Street"}
  validates :city, :first_name, :last_name, :presence => true
  validates :email,          :uniqueness => true
  validates :postal_code,    :format => {:with => /^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$/, :message => "was not recognized. eg. R3R 1G3"}

  def display_name
  	"#{self[:first_name]} #{self[:last_name]} #{self[:postal_code]}"
  end

end
