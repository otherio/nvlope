class Nvlope::MessageCollection

  include Enumerable

  def initialize nvlope, raw
    @nvlope, @raw = nvlope, raw
  end
  attr_reader :nvlope, :raw

  def to_a
    @to_a ||= raw['messages'].map do |raw|
      Nvlope::Message.new(nvlope, raw)
    end
  end

  def each &block
    to_a.each(&block)
  end

  alias_method :size, :count
  alias_method :length, :count

  def bookmark
    raw['bookmark']
  end

  def inspect
    %(#<#{self.class} #{size}>)
  end

end
