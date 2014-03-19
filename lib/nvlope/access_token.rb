class Nvlope::AccessToken < String

  def initialize nvlope, string
    @nvlope = nvlope
    super(string)
  end
  attr_reader :nvlope

end
