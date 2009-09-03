#Encoding: UTF-8
require "rubygems"
require "wx"

module Wx
  HTMLWindow = HtmlWindow
end

class Wx::Window
  alias background_colour= set_background_colour
  alias background_colour get_background_colour
  alias font= set_font
  alias font get_font
  alias foreground_colour= set_foreground_colour
  alias foreground_colour get_foreground_colour
end

class Wx::TopLevelWindow
  alias icon= set_icon
  alias icon get_icon
end

class Wx::Frame
  alias menu_bar= set_menu_bar
  alias title= set_title
end

class Wx::StaticText
  alias label= set_label
  alias label get_label
end

class Wx::Font
  alias point_size get_point_size
  alias point_size= set_point_size
end

class Wx::CheckBox
  alias is_checked? is_checked
  def check!
    set_value(true)
  end
  alias check check!
  def uncheck!
    set_value(false)
  end
  alias uncheck uncheck!
end

class Wx::TextCtrl
  alias text= set_value
  alias text get_value
end

class Wx::HTMLWindow
  alias page= set_page
end