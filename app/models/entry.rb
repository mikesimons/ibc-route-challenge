class Entry < ActiveRecord::Base
  validates_presence_of :name, :author, :entry
  validate :entry_is_ok
  before_save :calculate_distance

  named_scope :in_distance_order, :order => "distance asc"

  NODES = {
    "ibuildings london" => { :lat => 51.58701, :lon => -0.23029 }, 
    "area 51" => { :lat => 37.24348, :lon => -115.81143 },
    "eiffeltower" => { :lat => 48.85820, :lon => 2.29436 },
    "golden gate bridge" => { :lat => 37.81877, :lon => -122.47841 },
    "mount everest" => { :lat => 27.98002,:lon => 86.92154 },
    "big ben" => { :lat => 51.50070, :lon => -0.12426 },
    "zendcon" => { :lat => 37.32973, :lon => -121.88883 },
    "harbour, tokyo" => { :lat => 35.58333, :lon => 139.75000 },
    "taj mahal" => { :lat => 27.17486, :lon  => 78.04238 },
    "elephpant heaven" => { :lat => 52.37342, :lon => 4.89806 },
    "sydney opera" => { :lat => -33.85680, :lon => 151.21513 },
    "dutch php conference" => { :lat => 52.34139, :lon => 4.88833 }
  }

  def self.shortest
    Entry.all(:conditions => "distance = (SELECT MIN(distance) FROM entries LIMIT 1)", :limit => 1).first
  end

  def nodes
    (["ibuildings london"] + entry.downcase.gsub(/\r/, "\n").gsub(/\n+/, "\n").split("\n").to_a + ["dutch php conference"]).uniq
  end

  def entry_is_ok
    nodes.each do |n|
      errors.add :entry, "'#{n}' is not a valid node" unless NODES[n]
    end
    return errors.length == 0
  end

  def calculate_distance
    prev = nil
    d = 0
    nodes.each do |n|
      if prev.nil?
        prev = NODES[n]
        next
      end
      d += gcd(prev, NODES[n])
      prev = NODES[n]
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
