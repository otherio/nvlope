class Nvlope::Account

  def initialize nvlope, raw
    @nvlope = nvlope
    @id         = raw['id']
    @handle     = raw['handle']
    @first_name = raw['first_name']
    @last_name  = raw['last_name']
    @url        = raw['url']
    @company    = raw['company']
  end
  attr_reader :nvlope, :raw, :id, :handle, :first_name, :last_name, :url, :company

  def to_hash
    {
      id:         id,
      handle:     handle,
      first_name: first_name,
      last_name:  last_name,
      url:        url,
      company:    company,
    }
  end

  def inspect
    values = to_hash.map{|k,v| "#{k}: #{v.inspect}" }.join(', ')
    %(#<#{self.class} #{values}>)
  end

end
