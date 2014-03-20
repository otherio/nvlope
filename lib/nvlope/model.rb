class Nvlope::Model

  def self.key_to_method_name key
    key.downcase.gsub('-','_')
  end

  def self.keys *keys
    @keys ||= Set[]
    keys = keys.flatten.map(&:to_s).to_set
    keys.each do |key|
      define_method(key_to_method_name(key)){ raw[key] }
    end
    @keys += keys
    @keys + (superclass.respond_to?(:keys) ? superclass.keys : Set[])
  end

  def initialize nvlope, raw={}
    @nvlope, @raw = nvlope, raw
  end
  attr_reader :nvlope, :raw

  def to_hash
    self.class.keys.inject({}) do |hash, key|
      hash.update key => send(Nvlope::Model.key_to_method_name(key))
    end
  end

  def [] key
    raw[key.to_s]
  end

  def inspect
    values = to_hash.map{|k,v| "#{k}: #{v.inspect}" }.join(', ')
    %(#<#{self.class} #{values}>)
  end

end
