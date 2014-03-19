class Nvlope::Request

  def initialize nvlope, raw
    @nvlope, @raw = nvlope, raw
  end
  attr_reader :nvlope, :raw

end
