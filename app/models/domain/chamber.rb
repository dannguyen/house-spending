class Chamber < String
  include Singleton

  def initialize
    super(self.class.name)
  end

  def name; self.class.to_s end
  def member; end
  def members; "#{member}s"; end
  def title; member; end
  def ab_title; end

  def to_s; name; end
  def to_str; to_s; end 

#  def inspect; name; end 
end


def Chamber(str)
  return str if str.is_a?(Chamber)

  if str =~ /^(?:rep\.?\b|representative|house)/i
    return House.instance
  elsif str =~ /^(?:sen\.?\b|senator|senate)/i
    return Senate.instance
  else
    return nil
  end
end


class Senate < Chamber 
  def member; 'Senator'; end
  def ab_title; 'Sen.'; end   
end

class House < Chamber
  def member; 'Representative'; end
  def ab_title; 'Rep.'; end 

end