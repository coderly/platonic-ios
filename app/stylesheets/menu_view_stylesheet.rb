class MenuViewStylesheet < ApplicationStylesheet

  def root_view(st)
    st.background_color = color.clear
    st.view.separatorColor = color.clear
    st.view.rowHeight = 60
  end

  def table_header_view(st)
    st.background_color = color.clear
    st.frame = {w: app_width, h: 44}
  end

  def cell(st)
    st.background_color = color.clear
  end

  def menu_icon_area(st)
    st.frame = {l: 15, w: 32, h: 32}
    st.background_color = color.clear
    st.centered = :vertical
  end

  def menu_icon(st)
    st.background_color = color.clear
    st.centered = :both
  end

  def pointer_icon(st)
    st.frame = {w: 24, h: 32}
    st.image = image.resource('pointer_icon')
    menu_icon(st)
  end

  def messages_icon(st)
    st.frame = {w: 32, h: 28}
    st.image = image.resource('messages_icon')
    menu_icon(st)
  end

  def settings_icon(st)
    st.frame = {w: 32, h: 32}
    st.image = image.resource('settings_icon')
    menu_icon(st)
  end

  def invite_icon(st)
    st.frame = {w: 32, h: 32}
    st.image = image.resource('invite_icon')
    menu_icon(st)
  end

  def menu_label(st)
    st.frame = {l: 62, w: 200, h: 32}
    st.font = font.menu_label
    st.color = color.white
    st.centered = :vertical
  end

  def home_label(st)
    menu_label(st)
    st.text = "Home"
  end

  def messages_label(st)
    menu_label(st)
    st.text = "Messages"
  end

  def settings_label(st)
    menu_label(st)
    st.text = "Settings"
  end

  def invite_label(st)
    menu_label(st)
    st.text = "Invite"
  end

end