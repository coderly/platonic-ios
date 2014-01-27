class ServerAuth
  include Event::Observable


  class << self

    def setup
      shared.setup
    end

    def shared
      @shared ||= new(facebook_auth, api, persistence)
    end

    def facebook_auth
      FacebookAuth.shared
    end

    def api
      API.new(Environment.shared)
    end

    def persistence
      App::Persistence
    end
  end

  def initialize(facebook_auth, api, persistence, logger = Logger.shared)
    @facebook_auth = facebook_auth
    @api = api
    @persistence = persistence
    @logger = logger

    @token = nil
    facebook_auth.on :logged_in, &method(:facebook_auth_logged_in)
  end

  def setup
    facebook_auth.setup
    trigger_logged_in_state
  end

  def show_login_dialog
    facebook_auth.show_login_dialog
  end

  def logged_in?
    !logged_out?
  end

  def logged_out?
    token.nil?
  end

  def logout
    notify_server_of_logout
    self.token = nil
  end

  def token
    persistence['auth_token']
  end

  def token=(v)
    if token != v
      persistence['auth_token'] = v
      logger.info "persisted auth_token = #{token}"
      trigger_logged_in_state
    end
  end

  class << self
    attr_accessor :foo
  end

  private

  attr_reader :facebook_auth, :api, :persistence, :logger


  def trigger_logged_in_state
    trigger(:logged_in) if logged_in?
    trigger(:logged_out) if logged_out?
  end

  def facebook_auth_logged_in
    if facebook_auth.logged_in?
      fetch_auth_token
    end
  end

  def facebook_token
    facebook_auth.token
  end

  def fetch_auth_token
    @auth_token_request = api.post('login', token: facebook_token, device_id: device_id)
    @auth_token_request.success do |response|
      self.token = response.token
    end
  end

  def notify_server_of_logout
    api.post('logout', token: token)
  end

  def device
    Device.shared
  end

  def device_id
    device.key
  end

end