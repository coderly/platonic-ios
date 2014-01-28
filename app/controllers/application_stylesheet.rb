class ApplicationStylesheet < RubyMotionQuery::Stylesheet

  def application_setup
    font_family = 'Helvetica Neue'

    font.add_named :menu_label, font_family, 20
    font.add_named :notice, font_family, 10

    color.add_named :light_grey, '#555555'
    color.add_named :facebook_blue, '#3B5998'
  end

  def menu_button(st)
    st.frame = {w: 64, h: 64}
    st.image_normal = image.resource('menu_icon')
    st.image_highlighted = image.resource('menu_icon')
    st.background_color = color.clear
  end

end
