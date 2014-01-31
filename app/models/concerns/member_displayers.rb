module MemberDisplayers
  extend ActiveSupport::Concern

  def age
    ((Time.now - birthday) / (60 * 60 * 24 * 365)).floor
  end

  def mug_url
    "mugs/#{bioguide_id}.jpg"   
  end

  def name
    [chamber_title, first_name, last_name ].join(' ').squeeze(' ')
  end

  def full_name
    [first_name, middle_name, last_name].map(&:to_s).join(' ').squeeze(' ')
  end


  def party_state
    [party, state].join('-')
  end


  def tagline
    [party_state, district].compact.join('-')
  end

  def other_source_links
    INFO_SOURCE_LINKS.inject({}) do |h, (k,v)|
      h[k.to_s.chomp('_id').capitalize] = v
      h
    end
  end

  INFO_SOURCE_LINKS = {
        :bioguide_id => 'http://bioguide.congress.gov/scripts/biodisplay.pl?index=_ID_',
        :thomas_id => 'http://beta.congress.gov/member/-/_ID_',
        :govtrack_id => 'https://www.govtrack.us/congress/members/-/_ID_',
        :opensecrets_id => 'http://www.opensecrets.org/politicians/summary.php?cid=_ID_', 
        :votesmart_id => 'http://votesmart.org/candidate/_ID_/', 
        :wikipedia_id => 'http://en.wikipedia.org/wiki/_ID_/',
        :maplight_id => 'http://maplight.org/us-congress/legislator/_ID_'
     }

  INFO_SOURCE_LINKS.each_pair do |key, u|
    define_method(key.to_s.sub(/id$/, 'url')) do 
      u.sub(/_ID_/, self.send(key))
    end
  end

  def fec_urls
    fec_ids.map{ |fid| "http://www.fec.gov/fecviewer/CandidateCommitteeDetail.do?&tabIndex=3&candidateCommitteeId=#{fid}" }
  end

end

