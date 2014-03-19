class Nvlope::Arguments

  Error = Class.new(ArgumentError)

  def initialize hash
    hash.respond_to?(:to_hash) or raise ArgumentError, "Arguments should be a hash"
    @hash = hash.to_hash
  end

  def [] key
    @hash[key]
  end

  def require key
    return @hash[key] if @hash.key?(key)
    raise Error, "#{key} is a required option", caller(2)
  end

  def optional key
    return @hash[key] if @hash.key?(key)
    return yield if block_given?
  end

end
