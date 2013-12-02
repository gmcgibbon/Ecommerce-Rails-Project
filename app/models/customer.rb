class Customer < ActiveRecord::Base
  attr_accessible :address, :city, :country, :email, :first_name, :last_name, :postal_code

  belongs_to :province

  validates :address,        :format => {:with => /^[0-9]+ +\w+ +\w+$/, :message => "was not recognized. eg. 123 Blue Street"}
  validates :city, :country, :first_name, :last_name, :presence => true
  validates :email,          :format => {:with => /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/, :message => "was not recognized. eg. someone@example.com"}
  validates :postal_code,    :format => {:with => /^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$/, :message => "was not recognized. eg. R3R 1G3"}
end
