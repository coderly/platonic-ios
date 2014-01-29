class HomeController < UIViewController
	def viewDidLoad
    rmq.stylesheet = HomeStylesheet
    rmq(self.view).apply_style :root_view

    @picture_container = rmq.append(DraggableView, :picture_container).get

    @menu_button = UIButton.alloc.init
		@menu_button.setImage(UIImage.imageNamed("menu_icon"), forState:UIControlStateNormal)

    @menu_button.addTarget(self, action: :tapped_menu_button, forControlEvents:UIControlEventTouchUpInside)
    @menu_button.frame = CGRectMake(0,0,34,34)

    self.navigationItem.leftBarButtonItem = create_menu_button

    @logout_button = rmq.append(UIButton, :logout_button).get
    @logout_button.setTitle('Sign Out', forState: UIControlStateNormal)

    rmq(@logout_button).on(:tap) do |sender|
      rmq(sender).animations.throb(
        completion: -> (finished, q) {
          tapped_logout_button
        }
      )
    end

		true
	end

	private

	def tapped_menu_button
		self.sideMenuViewController.presentMenuViewController
	end

	def create_menu_button
		UIBarButtonItem.alloc.initWithCustomView(@menu_button)
	end

	def tapped_logout_button
		auth.logout
	end

	def auth
		ServerAuth.shared
	end
end