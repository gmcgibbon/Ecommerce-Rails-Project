class Page < ActiveRecord::Base
  attr_accessible :content, :title

  validates :title, uniqueness: true
  validates :content, :title, :presence => true
end
