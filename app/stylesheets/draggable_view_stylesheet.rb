class DraggableViewStylesheet < ApplicationStylesheet

  def like_label(st)
    st.view.alpha = 0
    st.font = font.menu_label
  end

  def liked(st)
    like_label(st)
    st.frame = {t: 10, l: 10, w: 100, h: 40 }
    st.color = color.green
    st.text = "Liked"
  end

  def disliked(st)
    like_label(st)
    st.frame = {t: 10, l: 190, w: 100, h: 40 }
    st.color = color.red
    st.text = "Nope"
  end

  def picture(st)
    st.frame = {w: 300, h: 225 }
    st.image = image.resource('girl')
  end
end