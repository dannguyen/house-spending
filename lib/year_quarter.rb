class YearQuarter
  include Comparable
  attr_reader :year, :quarter

  FIRST = "2009Q3"
  LAST = "2013Q3"

  def self.app_range
    new(FIRST)..new(LAST)
  end

  def initialize(*args)
    if args.length == 1
      vals = args[0].match(/(\d{4})-?Q(\d)$/)[1..2]
    else
      vals = args
    end

    @year, @quarter = vals.map{|a| a.to_i}

    raise ArgumentError, "the Quarter must be from 1 - 4, not #{@quarter}" unless (1..4).cover?(@quarter)
  end

  def <=>(other)
    self.inspect <=> other.inspect
  end

  def ==(other)
    self.to_s == other.to_s
  end
  alias_method :eql?, :==

  def inspect
    "#{@year}Q#{@quarter}"
  end

  def to_s
    inspect
  end

  def succ
    q = @quarter % 4
    y = q == 0 ? @year + 1 : @year

    return YearQuarter.new( y, q + 1)
  end

end
