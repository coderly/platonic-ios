class HomeStylesheet < ApplicationStylesheet

  def root_view(st)
    st.background_color = color.white
  end

  def picture_container(st)
    st.frame = {l: 10, t: 200, w: 300, h: 225 }
  end

  def logout_button(st)
    st.frame = {l: 40, w: 240, h: 44}
    st.from_bottom = 30
    st.background_color = color.facebook_blue
    st.view.layer.cornerRadius = 5
  end

end