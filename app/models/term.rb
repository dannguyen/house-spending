class Term < ActiveRecord::Base
  include CongressPoliticalDomain
  belongs_to :member, :primary_key => :bioguide_id, :foreign_key => :bioguide_id
  has_many :expenditures, 
    ->(r){where("expenditures.start_date >= ? AND expenditures.start_date < ?", r.start_date, r.end_date)},
    :primary_key => :bioguide_id, :foreign_key => :bioguide_id

  validates_uniqueness_of :start_date, scope: [:member_id, :chamber]

  scope :chronological, ->(){ order(:start_date)  }


  def length
    end_date - start_date
  end


  def span 
    [start_date, end_date].compact.map{|d| d.strftime "%b %e, %Y"}.join(' - ')
  end


  def self.total_length
    self.sum("end_date - start_date")
  end
  
end
