class Platform < ActiveRecord::Base
  attr_accessible :description, :manufacturer, :name

  has_many :games

  validates :description, :manufacturer, :name, :presence => true
  validates :name, uniqueness: true
end
