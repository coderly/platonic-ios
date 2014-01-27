class FacebookAuth
  include Event::Observable

  FBPermissions = ["email"]
  FACEBOOK_PRODUCTION_APP_ID = '571685872908504'

  def self.setup
    shared.setup # make sure shared auth object is initalized
  end

  def self.handleApplicationDidBecomeActive
    FBSettings.setAppVersion(NSBundle.mainBundle.infoDictionary.objectForKey("CFBundleShortVersionString"))
    FBSettings.setDefaultAppID(FACEBOOK_PRODUCTION_APP_ID)
    FBAppEvents.activateApp
    FBSession.activeSession.handleDidBecomeActive
  end

  def self.handleOpenURL(url)
    FBSession.activeSession.handleOpenURL(url)
  end

  def self.shared
    @shared ||= new
  end

  def initialize
  end

  def setup
    open_session false
  end

  def show_login_dialog
    open_session true
  end

  def logged_in?
    FBSession.activeSession.isOpen
  end

  def logged_out?
    not logged_in?
  end

  def logout
    FBSession.activeSession.closeAndClearTokenInformation
  end

  def token
    if logged_in?
      FBSession.activeSession.accessTokenData.accessToken
    else
      nil
    end
  end

  private

  def state
    @state
  end

  def state=(new_state)
    if state != new_state
      old_state, @state = @state, new_state
      on_state_changed(old_state, new_state)
    end
  end

  def open_session(show_dialog)
    completionBlock = Proc.new do |session, state, error|
      sessionStateChanged(session, state: state, error: error)
    end

    FBSession.openActiveSessionWithReadPermissions(FBPermissions,
                                                   allowLoginUI: show_dialog, completionHandler: completionBlock)
  end

  def sessionStateChanged(session, state: state, error: error)
    case state
      when FBSessionStateClosed, FBSessionStateClosedLoginFailed
        FBSession.activeSession.closeAndClearTokenInformation
    end

    self.state = state

    UIAlertView.alloc.initWithTitle("Error", message: error.localizedDescription,
                                    delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show if error
  end

  def on_state_changed(old, new)
    if new == FBSessionStateOpen
      trigger(:logged_in)
    end
  end
end