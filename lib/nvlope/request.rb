class Nvlope::Request

  Failed = Class.new(StandardError) do
    def initialize request, response
      @request, @response = request, response
      super("code: #{response.code}\n#{response.body}")
    end
    attr_reader :request, :response
  end

  include HTTParty

  def initialize nvlope, method, path, options={}
    @nvlope, @method, @path, @options = nvlope, method, path, options
    @url = File.join(nvlope.domain, nvlope.api_version, path)
  end
  attr_reader :nvlope, :method, :path, :url, :options

  def response
    @response ||= begin
      nvlope.logger.info "Nvlope request: #{method.to_s.upcase} #{url} #{options.inspect}"
      HTTParty.send(method, url, options)
    end
  end

  def perform
    response
  end

  def perform!
    case response.code
    when 200..299
      return response
    else
      raise Failed.new(response.request, response)
    end
  end

end
