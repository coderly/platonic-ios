class SplashStylesheet < ApplicationStylesheet

  def root_view(st)
    st.background_color = color.white
  end

  def facebook_button(st)
    st.frame = {l: 40, w: 240, h: 44}
    st.from_bottom = 30
    st.background_color = color.facebook_blue
    st.view.layer.cornerRadius = 5
  end

  def facebook_notice_label(st)
    st.frame = {w: 320, h: 30}
    st.from_bottom = 0
    st.color = color.light_grey
    st.text_alignment = :center
    st.text = "We'll never post anything to Facebook."
    st.font = font.notice
  end
end