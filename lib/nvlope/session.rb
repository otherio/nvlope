class Nvlope::Session

  def initialize nvlope, raw
    @nvlope, @raw = nvlope, raw
  end
  attr_reader :nvlope, :raw

  def access_token
    @access_token ||= Nvlope::AccessToken.new(nvlope, raw['access_token'])
  end

  def account
    @account ||= Nvlope::Account.new(nvlope, raw['account'])
  end

  def client
    @client ||= Nvlope::Client.new(nvlope, raw['access_token'])
  end

  def inspect
    %(#<#{self.class} access_token: #{access_token.inspect}, account: #{account.inspect}, client: #{client.inspect}>)
  end

end
