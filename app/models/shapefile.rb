class Shapefile < ActiveRecord::Base
  attr_accessible :identifier, :shapefile, :condition, :projection, :note
  belongs_to :version
  has_attached_file :shapefile,
                    :path => "/home/ntb/Public/system/:attachment/:id/:filename",
                    :url => "/system/:attachment/:id/:filename"

  validates :projection, :numericality => true

  def self.valid_for_processing(type)
    Shapefile.select("identifier").where(:condition => 'Processed').collect{|shp| shp.identifier}.include?(InspireFactory.identifier(type))
  end

  def update_condition(condition, features_processed = 0)
    self.condition = condition
    self.features = features_processed
    self.save!

    version = self.version
    version.active = true
    version.save!
  end
end
