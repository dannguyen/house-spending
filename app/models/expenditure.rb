require 'personnel_record'

class Expenditure < ActiveRecord::Base
  belongs_to :member, :primary_key => :bioguide_id, :foreign_key => :bioguide_id
  # belongs_to :term, 
  #   ->(r){where("terms.start_date <= ? AND terms.end_date > ?", r.start_date, r.start_date)},
  #   :primary_key => :bioguide_id, :foreign_key => :bioguide_id

  scope :personnel, ->(){where(category: 'PERSONNEL COMPENSATION').order('payee ASC, start_date ASC')}



  def self.day_rate

    
  end
end
