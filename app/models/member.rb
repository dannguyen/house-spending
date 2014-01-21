class Member < ActiveRecord::Base
  
  include MemberDisplayers
  include CongressPoliticalDomain
  include SunlightMemberImport

  extend FriendlyId
  friendly_id :bioguide_id, use: [:finders]

  validates_uniqueness_of :bioguide_id
  validates_presence_of :bioguide_id
  
  serialize :fec_ids, Array

  has_many :terms, :dependent => :delete_all
  has_many :expenditures, :primary_key => :bioguide_id, :foreign_key => :bioguide_id
  has_one :latest_term, ->{ order("start_date DESC")}, class_name: 'Term'
  has_one :current_term, ->{order("start_date DESC").where('end_date > ?', Time.now ) }, class_name: 'Term'


  def senator?
    chamber == 'Senate'
  end

  def rep?
    chamber ==  'House'
  end

  def personnel_records
    PersonnelRecord(expenditures.personnel)
  end

  def total_term_length
    terms.total_length
  end


end
