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

    true
	end

	private

	def tapped_auth_button
		auth.show_login_dialog
	end

  def auth
    ServerAuth.shared
  end
end