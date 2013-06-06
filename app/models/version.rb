class Version < ActiveRecord::Base
  attr_accessible :name, :description, :shapefiles, :shapefiles_attributes, :user_id, :active

  belongs_to :user
  has_many :shapefiles, :dependent => :destroy
  scope :active, where(:active => true)
  scope :archived, where(:archived => true)

  # Using PG_Search functionality
  include PgSearch
  pg_search_scope :search_by_description, :against => [:name, :description, :created_at]


  validates :name, :description, :shapefiles, :user_id, :presence => true
  validates :name, :uniqueness => true
  before_save :remove_empty_shapefiles

  accepts_nested_attributes_for :shapefiles

  def generate_shapefiles
    inspire_packets = ['Geographical Names', 'Administrative Units', 'Cadastral Parcels']
    active_shapefiles = []

    versions = Version.where(:active => true)
    versions.each do |version|
      active_shapefiles.concat(version.shapefiles.collect{ |shapefile| shapefile.identifier })
    end

    (inspire_packets - active_shapefiles).each do |pack|
      self.shapefiles.new(:identifier => pack)
    end
  end

  private
  def remove_empty_shapefiles
    self.shapefiles.delete_if {|shapefile| shapefile.shapefile_file_name.nil?}
    raise ArgumentError if self.shapefiles.empty?
  rescue => e
    self.generate_shapefiles()
    errors.add(:base, 'Non shapefiles added.')
    false
  end

end
