class Result
  include EM::Deferrable

  alias_method :success, :callback
  alias_method :failure, :errback

  attr_reader :indicator

  attr_accessor :error_message, :operation

  def initialize
    super

    @error_message = "An unexpected error occurred. Please contact support."
    @indicator = false
    @has_shown_indicator = false

    success &method(:on_success)
    failure &method(:on_failure)
  end

  def indicator=(v)
    @indicator = v
    if @indicator && !@has_shown_indicator
      notifier.loading
      @has_shown_indicator = true
    end
  end

  private

  def on_success(response)
    if indicator.is_a?(String)
      message = indicator
      notifier.succeed(indicator)
    elsif indicator
      notifier.succeed
    end
  end

  def on_failure(response)
    notifier.fail if indicator

    error = extract_error(response)

    if error[:error_message]
      alert_error error[:error_message]
    elsif error_message
      alert_error(error_message)
    end
  end

  def extract_error(response)
    json = response.userInfo['NSLocalizedRecoverySuggestion']
    return {} if json.nil?

    data = json.dataUsingEncoding(NSUTF8StringEncoding)
    error_pointer = Pointer.new(:id)
    error_response = NSJSONSerialization.JSONObjectWithData(data, options:0, error: error_pointer)
    error_response || {}
  end

  def notifier
    Notifier.shared
  end

  def alert_error(message)
    App.alert("Error",
              {
                  cancel_button_title: "Okay",
                  message: message
              }
    )
  end

end
