class AppDelegate
  def self.shared
    UIApplication.sharedApplication.delegate
  end

  def env
    Environment.shared
  end

  def logger
    Logger.shared
  end

  def api
    API.shared
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    auth.on(:logged_in) { logger.info "logged in" }
    auth.on(:logged_out) { logger.info "logged out" }

    auth.on(:logged_in) { setup_window_for_logged_in_user }
    auth.on(:logged_out) { setup_window_for_logged_out_user }

    # must be called after the listeners are attached so that the initial trigger works
    ServerAuth.setup

    true
  end

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def auth
    @auth ||= ServerAuth.shared
  end

  def splash_controller
    @splash_controller ||= SplashController.alloc.initWithNibName(nil, bundle:nil)
  end

  def applicationDidBecomeActive(application)
    FacebookAuth.handleApplicationDidBecomeActive
	end

  def application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    FacebookAuth.handleOpenURL(url)
  end

  def setup_window_for_logged_in_user
    # Context.shared.reload do |r|
      # if onboarded?
      #   window.rootViewController = slide_menu_controller
      # else
      #   window.rootViewController = onboarding_flow_controller
      # end

    side_menu_controller.backgroundImage = UIImage.imageNamed("Stars")
    window.rootViewController = side_menu_controller

    show_window_if_hidden
    # end
  end

  def setup_window_for_logged_out_user
    side_menu_controller.backgroundImage = UIImage.imageNamed("Stars")
    window.rootViewController = side_menu_controller
    show_window_if_hidden
  end

  def navigation_controller
    @navigation_controller ||= NavigationController.alloc.initWithRootViewController(splash_controller)
  end

  def splash_controller
    @splash_controller ||= SplashController.alloc.init
  end

  def menu_controller
    @menu_controller ||= MenuViewController.alloc.initWithStyle(UITableViewStylePlain)
  end

  def side_menu_controller
    @side_menu_controller ||= RESideMenu.alloc.initWithContentViewController(navigation_controller, menuViewController: menu_controller)
  end

  def show_window_if_hidden
    return unless window.hidden?

    # appearance = NavigationBarAppearance.setup
    # appearance.style

    window.makeKeyAndVisible
  end
end
