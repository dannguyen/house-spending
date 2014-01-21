class PoliticalParty < String
  include Singleton

  def initialize
    super(self.class.abbrev)
  end

  def name; end
  def members; "#{member}s"; end
  def title; member; end
  def abbrev; self.class.abbrev; end
  def member; end
  def adjective; name; end

  def inspect; to_s; end 

  def self.abbrev; end

end


def PoliticalParty(str)
  return str if str.is_a?(PoliticalParty)

  if str =~ /(?:\bD\b|democrat(:?ic)?|\bD-\w+)/i
    return Democratic.instance
  elsif str =~ /(?:\bR\b|republican|\bR-\w+)/i
    return Republican.instance
  elsif str =~ /(?:\bI\b|independent|\bI-\w+)/i
    return Independent.instance
  elsif str =~ /(?:\bG\b|green|\bG-\w+)/i
    return Green.instance
  else
    return nil
  end
end


class Republican < PoliticalParty 
  def self.abbrev; 'R'; end
  def title; 'Republican'; end
  def member; 'Republican'; end
end

class Democratic < PoliticalParty 
  def self.abbrev; 'D'; end
  def title; 'Democratic'; end
  def member; 'Democrat'; end
end

class Independent < PoliticalParty 
  def self.abbrev; 'I'; end
  def title; 'Independent'; end
  def member; 'Independent'; end
end

class Green < PoliticalParty 
  def self.abbrev; 'G'; end
  def title; 'Green'; end
  def member; 'Green'; end
end
