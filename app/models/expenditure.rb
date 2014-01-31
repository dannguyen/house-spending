require 'personnel_record'

class Expenditure < ActiveRecord::Base
  belongs_to :member, :primary_key => :bioguide_id, :foreign_key => :bioguide_id
  # belongs_to :term, 
  #   ->(r){where("terms.start_date <= ? AND terms.end_date > ?", r.start_date, r.start_date)},
  #   :primary_key => :bioguide_id, :foreign_key => :bioguide_id

  scope :personnel, ->(){where(category: 'PERSONNEL COMPENSATION').order('payee ASC, start_date ASC')}

  MISC_CATEGORIES = ["PRINTING AND REPRODUCTION", "FRANKED MAIL", "TRANSPORTATION OF THINGS", "OTHER SERVICES"]
  RENT_EQ_CATEGORIES = ["RENT, COMMUNICATION, UTILITIES", "EQUIPMENT", "SUPPLIES AND MATERIALS"]

  def self.day_rate

    
  end


  # returns a Hash:
  def self.grouped_quarterly
    coll = self.group(:quarter, :category).sum(:amount)
    YearQuarter.app_range.inject({}) do |hsh, quarter|
      grouped = coll.select{|k,v| k[0] == quarter.to_s}.inject(Hash.new{|n,m| n[m] = 0}) do |h, (a, b)|
        cat = simplify_cat(a[1]) 
        h[cat] += b.to_i

        h
      end
      hsh[quarter] = grouped unless grouped.empty?

      hsh
    end
  end

  def self.simplify_cat(name)
    cat = if MISC_CATEGORIES.include?(name)
      'MISC' 
    elsif RENT_EQ_CATEGORIES.include?(name)
      'RENT, SUPPLIES, EQUIPMENT'
    else
      name
    end        
  end

  # refactor later
  def self.grouped_total
    self.group(:category).sum(:amount).inject(Hash.new{|n,m| n[m] = 0}) do |hsh, (k,v)| 
      cat = simplify_cat(k) 
      hsh[cat] += v.to_i
      hsh
    end.sort_by{|k,v| v}
  end


end
