
class Game < ActiveRecord::Base
  attr_accessible :box_art, :developer, :genre, :name, :price, :rating, :stock_quantity, :platform_id

  mount_uploader :box_art, BoxArtUploader

  belongs_to :platform
  
  validates :name, :box_art, uniqueness: true
  validates :developer, :genre, :name, :box_art, :presence => true
  validates :price,          :numericality => {:greater_than_or_equal_to => 0.01}
  validates :stock_quantity, :numericality => {:only_integer => true}
  validates :rating,         :format => {:with => /^(Early Childhood|Everyone|Everyone 10\+|Teen|Mature|Adults Only)$/, :message => "was not recognized. eg. Everyone 10+"}
end
