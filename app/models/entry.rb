class Entry < ActiveRecord::Base
  belongs_to :dataset

  validates_presence_of :name, :entry
  validate :dataset_exists, :entry_is_ok, :all_nodes_present
  before_save :calculate_distance

  named_scope :in_distance_order, :order => "distance asc"
  named_scope :shortest, :conditions => "distance = (SELECT MIN(distance) FROM entries LIMIT 1)", :limit => 1
  named_scope :for_dataset, lambda { |d| d = d.id if d.is_a? Dataset; { :conditions => ["dataset_id = ?", d] } }

  def nodes
    (entry.downcase.gsub(/\r/, "\n").gsub(/\n+/, "\n").split("\n").to_a).uniq
  end

  def all_nodes_present
    dsn = self.dataset.data_as_hash
    present_nodes = nodes
    nodes.each do |n|
      dsn.delete n
    end
    errors.add :entry, "is missing some nodes ('#{dsn.keys.sort.join("', '")}')" if dsn.length > 0
  end

  def entry_is_ok
    dsn = self.dataset.data_as_hash
    nodes.each do |n|
      errors.add :entry, "'#{n}' is not a valid node" unless dsn[n]
    end
    return errors.length == 0
  end

  def dataset_exists
    errors.add_to_base "Invalid dataset!" if self.dataset.nil?
  end

  def calculate_distance
    dsn = self.dataset.data_as_hash
    prev = nil
    d = 0
    nodes.each do |n|
      if prev.nil?
        prev = dsn[n]
        next
      end
      d += gcd(prev, dsn[n])
      prev = dsn[n]
    end
    self.distance = d
  end

  def gcd(p1, p2)
    rlat1 = deg2rad p1[:lat]; rlon1 = deg2rad p1[:lon]; rlat2 = deg2rad p2[:lat]; rlon2 = deg2rad p2[:lon]
    return 6372.797 * Math.acos(Math.sin(rlat1) * Math.sin(rlat2) +  Math.cos(rlat1) * Math.cos(rlat2) * Math.cos(rlon1 - rlon2))
  end

  DEGREES_PER_RAD = Math::PI / 180
  def deg2rad(d)
    d * DEGREES_PER_RAD
  end
end
