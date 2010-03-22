class Entry < ActiveRecord::Base
  belongs_to :dataset

  validates_presence_of :name, :entry
  validate :dataset_exists, :entry_is_ok, :all_nodes_present, :first_and_last_are_valid
  before_validation :prepend_start_append_end
  before_save :calculate_distance

  named_scope :in_distance_order, :order => "distance asc"
  named_scope :shortest_for_dataset, lambda { |d|
    d = d.id if d.is_a? Dataset
    {
      :conditions => ["dataset_id = ? and distance = (SELECT MIN(distance) FROM entries where dataset_id = ? LIMIT 1)", d, d],
      :limit => 1
    }
  }

  named_scope :for_dataset, lambda { |d| d = d.id if d.is_a? Dataset; { :conditions => ["dataset_id = ?", d] } }

  def nodes
    (entry.downcase.gsub(/\r/, "\n").gsub(/\n+/, "\n").split("\n").to_a).uniq
  end

  def all_nodes_present
    dsn = self.dataset.data_as_hash
    nodes.each { |n| dsn.delete n }
    errors.add :entry, "is missing some nodes ('#{dsn.keys.sort.join("', '")}')" if dsn.length > 0
    return errors.length == 0
  end

  def entry_is_ok
    dsn = self.dataset.data_as_hash
    nodes.each do |n|
      errors.add :entry, "'#{n}' is not a valid node" unless dsn[n]
    end
    return errors.length == 0
  end

  def first_and_last_are_valid
    dsn = self.dataset.data_as_array
    errors.add :entry, "must start at '#{dsn.first[0]}'" if nodes.first.downcase != dsn.first[0].downcase
    errors.add :entry, "must end at '#{dsn.last[0]}'" if nodes.last.downcase != dsn.last[0].downcase
    return errors.length == 0
  end

  def dataset_exists
    errors.add_to_base "Invalid dataset!" if self.dataset.nil?
  end

  def prepend_start_append_end
    dsn = self.dataset.data_as_array
    self.entry = "#{dsn.first[0]}\n#{self.entry}" if self.nodes.first != dsn.first[0]
    self.entry += "\n#{dsn.last[0]}" if self.nodes.last != dsn.last[0]
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
      d += haversine(prev, dsn[n])
      prev = dsn[n]
    end
    self.distance = d
  end

  def haversine(p1, p2)
    rlat1 = deg2rad p1[:lat]; rlon1 = deg2rad p1[:lon]; rlat2 = deg2rad p2[:lat]; rlon2 = deg2rad p2[:lon]

    hdlat = (rlat2 - rlat1) * 0.5
    hdlon = (rlon2 - rlon1) * 0.5

    a = Math.sin(hdlat) ** 2 + Math.cos(rlat1) * Math.cos(rlat2) * Math.sin(hdlon) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    return 6372.797 * c
  end

  DEGREES_PER_RAD = Math::PI / 180

  def deg2rad(d)
    d * DEGREES_PER_RAD
  end
end
