class Mapping < ActiveRecord::Base
  attr_accessible :name, :mapping_type, :data
  validates :name, :presence => true, :uniqueness => true

  belongs_to :user
end
