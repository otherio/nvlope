require 'uri'
require 'httparty'
require 'nvlope/version'

class Nvlope

  autoload :Arguments,         'nvlope/arguments'
  autoload :Model,             'nvlope/model'
  autoload :Session,           'nvlope/session'
  autoload :AccessToken,       'nvlope/access_token'
  autoload :Account,           'nvlope/account'
  autoload :Client,            'nvlope/client'
  autoload :Messages,          'nvlope/messages'
  autoload :MessageCollection, 'nvlope/message_collection'
  autoload :Message,           'nvlope/message'
  autoload :EmailAddress,      'nvlope/email_address'

  def self.Arguments hash
    Nvlope::Arguments.new hash
  end

  def initialize arguments
    arguments = Nvlope::Arguments(arguments)

    @username       = arguments.require(:username     ).to_s
    @password       = arguments.require(:password     ).to_s
    @client_id      = arguments.require(:client_id    ).to_s
    @client_secret  = arguments.require(:client_secret).to_s
    @grant_type     = arguments.optional(:grant_type ){ 'password'                }.to_s
    @domain         = arguments.optional(:domain     ){ 'https://api.nvlope.com/' }.to_s
    @api_version    = arguments.optional(:api_version){ 'v1'                      }.to_s
  end

  attr_accessor :grant_type, :username, :password, :client_id, :client_secret, :domain, :api_version

  def url path
    File.join(domain, api_version, path)
  end

  def access_token
    @access_token ||= AccessToken.new(self, get_access_token)
  end

  def session
    @session ||= Session.new(self, get_session)
  end

  def messages
    @messages ||= Messages.new(self)
  end

  def request method, path, query={}, headers={}
    headers['Authorization'] ||= "Bearer #{access_token}"
    url = url(path)
    # puts "Nvlope: #{method.upcase} #{url}"
    HTTParty.send(method, url, query: query, headers: headers)
  end


  def get_access_token
    @access_token = begin
      url = url('oauth2/token')
      # puts "Nvlope: POST #{url}"
      response = HTTParty.post(url, query:{
        grant_type:    grant_type,
        username:      username,
        password:      password,
        client_id:     client_id,
        client_secret: client_secret,
      })
      response['access_token']
    end
  end

  def revoke_access_token
    # DELETE v1/oauth2/token
    response = request(:delete, 'oauth2/token')
    return false unless response.code < 300
    @access_token = nil
    response
  end

  def get_session
    request(:get, '/oauth2/session')
  end


  def to_hash
    {
      username:      username,
      password:      password,
      client_id:     client_id,
      client_secret: client_secret,
      grant_type:    grant_type,
      domain:        domain,
      api_version:   api_version,
    }
  end

  def inspect
    attributes = to_hash.map{|k,v| "#{k}: #{v.inspect}" }.join(', ')
    %(#<#{self.class} #{attributes}>)
  end

end
