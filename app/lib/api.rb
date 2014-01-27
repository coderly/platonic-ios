class API
  include Event::Observable

  class ParameterMissingError < StandardError
  end

  def self.shared
    @shared ||= new(Environment.shared, ServerAuth.shared, Logger.shared)
  end

  class NilAuth
    def token; nil end
  end

  def initialize(env, auth = NilAuth.new, logger = Logger.shared)
    @env = env
    @auth = auth
    @logger = logger
  end

  def get(path, params = {})
    request(:get, path, params)
  end

  def post(path, params = {})
    request(:post, path, params)
  end

  private

  attr_reader :env, :auth, :logger

  def base_url
    env.base_url
  end

  def request(method, path, params = {})
    params = Hashie::Mash.new(params)
    result = Result.new

    params = base_params.merge(params)
    path, params = substitute_placeholders(path, params)

    watch = Stopwatch.new
    watch.start

    logger.info "#{method.to_s.upcase} to #{path}"
    result.operation = client.public_send(method, path, params) do |response|
      watch.stop

      success_or_failure = response.success? ? "SUCCESS" : "FAILURE"
      logger.info "#{method.to_s.upcase} to #{path} ... #{success_or_failure} in #{watch.seconds_elapsed}s on #{base_url}"
      logger.info "Request headers: #{result.operation.request.allHTTPHeaderFields}"
      logger.info "Params: #{params}"

      logger.info "Response headers: #{result.operation.response.allHeaderFields}"
      if response.success?
        logger.info "Response object: #{response.object}"
        result.succeed(Hashie::Mash.new response.object)
      elsif response.failure?
        logger.info "Response error: #{response.error.localizedDescription}"
        result.fail(response.error)
      end

      logger.info "\n"
    end
    result
  end

  PLACEHOLDER_PATTERN = /:[a-z]\w*/

  def substitute_placeholders(path, params = {})
    new_params = params.clone
    new_path = path.gsub(PLACEHOLDER_PATTERN) do |placeholder|
      key = placeholder[1..-1]
      raise ParameterMissingError, "The #{key} parameter is missing or empty" if params[key].to_s.empty?
      params[key]
      new_params.delete(key)
    end

    [new_path, params]
  end

  def base_params
    if token
      {token: token}
    else
      {}
    end
  end

  def token
    auth.token
  end

  def client
    AFMotion::Client.build(base_url) do
      header "Accept", "application/json"
      response_serializer :json
    end
  end

end