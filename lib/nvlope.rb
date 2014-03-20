require 'uri'
require 'httparty'
require 'nvlope/version'
require 'logger'

class Nvlope

  autoload :Arguments,         'nvlope/arguments'
  autoload :Model,             'nvlope/model'
  autoload :Request,           'nvlope/request'
  autoload :Session,           'nvlope/session'
  autoload :AccessToken,       'nvlope/access_token'
  autoload :Account,           'nvlope/account'
  autoload :Client,            'nvlope/client'
  autoload :Messages,          'nvlope/messages'
  autoload :MessageCollection, 'nvlope/message_collection'
  autoload :Message,           'nvlope/message'
  autoload :EmailAddress,      'nvlope/email_address'

  class << self
    def Arguments hash
      Nvlope::Arguments.new hash
    end

    def logger
      @logger ||= Logger.new('/dev/null')
    end
    attr_writer :logger
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
    @logger         = arguments.optional(:logger)
  end

  attr_accessor :grant_type, :username, :password, :client_id, :client_secret, :domain, :api_version

  def logger
    @logger || self.class.logger
  end
  attr_writer :logger

  def access_token?
    !@access_token.nil?
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

  def unauthenticated_request method, path, options={}
    Request.new(self, method, path, options).perform!
  end

  def authenticated_request method, path, options={}
    options[:headers] ||= {}
    options[:headers]['Authorization'] ||= "Bearer #{access_token}"
    Request.new(self, method, path, options).perform!
  end

  def get_access_token
    @access_token = begin
      response = unauthenticated_request(:post, 'oauth2/token',
        query: {
          grant_type:    grant_type,
          username:      username,
          password:      password,
          client_id:     client_id,
          client_secret: client_secret,
        }
      )
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
