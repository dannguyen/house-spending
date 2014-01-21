module SunlightMemberImport
  extend ActiveSupport::Concern

  CURRENT_CONGRESS_DATA_HOLD = Rails.root.join('db', 'data-hold', 'congress-legislators', 'legislators').to_s


  INFO_SOURCE_ATTRIBUTES = [ 
      :bioguide_id,
      :thomas_id, 
      :govtrack_id, 
      :opensecrets_id, 
      :votesmart_id, 
      :icpsr_id, 
      :fec_ids, 
      :cspan_id, 
      :wikipedia_id, 
      :house_history_id, 
      :ballotpedia_id, 
      :maplight_id, 
      :washington_post_id
   ]


  def sync_and_save
    sync_latest_term_attributes

    self.save
  end


  def sync_latest_term_attributes!
    sync_latest_term_attributes

    self.save if self.changed?
  end

  def sync_latest_term_attributes
    if t = latest_term
      self.party = PoliticalParty(t.party)
      self.chamber = Chamber(t.chamber)
      self.state = t.state
      self.term_start_date = t.start_date
      self.term_end_date = t.end_date
      self.district = t.district
    end
  end

  

  module ClassMethods
    def build_from_sunlight_object(o)
      # import info_ids
      data = Hashie::Mash.new(o)  
      h = Hashie::Mash.new
  
      if name = data.name
        h[:first_name] = name[:first]
        h[:last_name] = name[:last]
        h[:middle_name] = name[:middle]
      end

      if bio = data.bio
        [:birthday, :gender, :religion].each{|k| h[k] = bio[k]}
      end


      h.merge!(parse_info_source_attributes(data))

      member = h.inject(Member.new) do |m, (att,val)|
        m.send :write_attribute, att, val
        m 
      end

      # now add dependencies, such as :terms
      build_dependencies_from_sunlight_object(member, data)

      return member
    end

    # obj is a hashie mash at this time
    def build_dependencies_from_sunlight_object(member, obj)
      parse_terms_array(obj).each do |term|
        member.terms.build(permit_all_the_things(term))
      end
    end

    ## FOR INFO SOURCE ID ATTRIBUTES
    # expects obj to have :id
    def parse_info_source_attributes(o)
      obj = o.stringify_keys

      ids = obj["id"] || {}
      infoatts = INFO_SOURCE_ATTRIBUTES.inject({}) do |hsh, att_name|
        source_name = att_name.to_s.match( /\w+?(?=_ids?$)/).to_s
        hsh[att_name] = ids[source_name]

        hsh
      end   

      return infoatts
    end

    # arr is the :terms array of the standard YAML object
      # terms:
      # - type: rep
      #   start: '1987-01-06'
      #   end: '1988-10-22'
      #   state: CA
      #   district: 5
      #   party: Democrat
      # - type: rep
      #   start: '1989-01-03'
      #   end: '1990-10-28'
      #   state: CA
      #   district: 5


    def parse_terms_array(obj)
      array = obj.is_a?(Array) ? obj : Array(obj[:terms])

      array.map do |a|        
        Hashie::Mash.new.tap do |t|
          t.start_date = a[:start]
          t.end_date = a[:end]
          t.senate_class = a[:class]
          t.state = a[:state]
          t.district = a[:district]
          t.chamber = Chamber a[:type]
          t.party = PoliticalParty a[:party]
        end
      end
    end

  end





end