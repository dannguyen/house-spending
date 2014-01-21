require 'domain/chamber'
require 'domain/political_party'
require 'year_quarter'
module CongressPoliticalDomain

  extend ActiveSupport::Concern

  included do 

    if self.column_names.include?('party')
      scope :democratic, ->{where(party: PoliticalParty('D') )}
      scope :republican, ->{where(party: PoliticalParty('R') )}
      scope :independent, ->{where(party: PoliticalParty('I') )}
      scope :r, ->{republican}
      scope :d, ->{democratic}
      scope :i, ->{independent}
      scope :republicans, ->{republican}
      scope :democrats, ->{democratic}
      scope :independents, ->{independent}
      scope :house, ->{where(chamber: Chamber('house'))}
      scope :senate, ->{where(chamber: Chamber('senate'))}
      scope :reps, ->{house}
      scope :senators, ->{senate}
    end

    if self.column_names.include?('congress_number')
      scope :latest_congress, ->{where(congress_number: CongressionalNumber.latest.to_i)}
      scope :current_congress, ->{where(congress_number: CongressionalNumber.current.to_i)}
    end
  end

  def chamber
    Chamber(read_attribute :chamber)
  end

  def chamber_title
    chamber.present? ? chamber.member : ''
  end


  def party
    PoliticalParty(read_attribute :party)
  end


end