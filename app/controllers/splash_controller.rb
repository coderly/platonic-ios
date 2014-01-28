class SplashController < UIViewController

  def viewDidLoad
    rmq.stylesheet = SplashStylesheet
    rmq(self.view).apply_style :root_view

    @facebook_button = rmq.append(UIButton, :facebook_button).get
    @facebook_button.setTitle('Log In with Facebook', forState: UIControlStateNormal)

    rmq.append(UILabel, :facebook_notice_label)

    rmq(@facebook_button).on(:tap) do |sender|
      rmq(sender).animations.throb(
        completion: -> (finished, q) {
          tapped_auth_button
        }
      )
    end

    @menu_button = UIButton.alloc.init
		@menu_button.setImage(UIImage.imageNamed("menu_icon"), forState:UIControlStateNormal)

    @menu_button.addTarget(self, action: :tapped_menu_button, forControlEvents:UIControlEventTouchUpInside)
    @menu_button.frame = CGRectMake(0,0,34,34)

    # @menu_button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);


    # rmq(@menu_button).on(:tap) do |sender|
    #   tapped_menu_button
    # end

    self.navigationItem.leftBarButtonItem = create_menu_button


    true
	end

	private

	def tapped_auth_button
		auth.show_login_dialog
	end

	def tapped_menu_button
		self.sideMenuViewController.presentMenuViewController
	end

  def auth
    ServerAuth.shared
  end

	def create_menu_button
		UIBarButtonItem.alloc.initWithCustomView(@menu_button)
	end

	def on_tap_reveal_menu
		self.sideMenuViewController.presentMenuViewController
	end
end