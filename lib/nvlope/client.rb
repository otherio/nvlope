class Nvlope::Client

  def initialize nvlope, raw
    @nvlope = nvlope
    @id          = raw['id']
    @name        = raw['name']
    @description = raw['description']
    @url         = raw['url']
    @image_url   = raw['image_url']
  end
  attr_reader :nvlope, :raw, :id, :name, :description, :url, :image_url

  def to_hash
    {
      id:          id,
      name:        name,
      description: description,
      url:         url,
      image_url:   image_url,
    }
  end

  def inspect
    values = to_hash.map{|k,v| "#{k}: #{v.inspect}" }.join(', ')
    %(#<#{self.class} #{values}>)
  end

end
