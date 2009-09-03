#!/usr/bin/env ruby
#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
#
#This program displays information about the currently selected window 
#and the mouse. The displayed infos are updated every 1/2 second, 
#but set XInfo::UPDATE_TIME to another value if you'd like to change that. 
require_relative("../lib/xdo/xwindow")
require_relative("../lib/xdo/mouse")
require "wx"
require_relative("../lib/xdo/wxaliases")

puts "=" * 80
puts "Started: #{Time.now}"
at_exit{puts "Finished: #{Time.now}"}


#--
#=================================================
#Backend
#=================================================
#++

#Class that retrieves the information of windows. 
class InfoGetter
  
  attr_reader :act_win
  attr_reader :cursorpos
  
  def initialize
    @act_win = XDo::XWindow.from_active
    @cursorpos = XDo::Mouse.position
  end
  
  def update
    @act_win = XDo::XWindow.from_active
    @cursorpos = XDo::Mouse.position
  end
  
end

#--
#=================================================
#Frontend
#=================================================
#++
include Wx

#Frontend of this program. 
class XInfo < App
  
  #Time intervall of updating the infos, in milliseconds. 
  #Default is 500, which is 1/2 second. 
  UPDATE_TIME = 500
  
  def on_init
    puts "Creating main window"
    @mainwindow = Frame.new(nil, -1, "XInfo", DEFAULT_POSITION, Size.new(300, 400), DEFAULT_FRAME_STYLE | STAY_ON_TOP)
    @mainwindow.background_colour = NULL_COLOUR
    puts "Creating controls"
    create_controls
    puts "Setting up timer"
    create_updater
    
    puts "Display GUI"
    @mainwindow.show
  end
  
  def create_controls
    StaticText.new(@mainwindow, -1, "Title of active window: ", Point.new(20, 20))
    @title = TextCtrl.new(@mainwindow, -1, "", Point.new(20, 50), Size.new(260, 24), TE_READONLY)
    StaticText.new(@mainwindow, -1, "ID of active window: ", Point.new(20, 80))
    @id = TextCtrl.new(@mainwindow, -1, "", Point.new(20, 110), Size.new(260, 24), TE_READONLY)
    StaticText.new(@mainwindow, -1, "Absoloute and relative upper-left coords: ", Point.new(20,140))
    StaticText.new(@mainwindow, -1, "Abs: ", Point.new(20, 173))
    @abs_xy = TextCtrl.new(@mainwindow, -1, "", Point.new(60, 170), Size.new(70, 24), TE_READONLY)
    StaticText.new(@mainwindow, -1, "Rel: ", Point.new(150, 173))
    @rel_xy = TextCtrl.new(@mainwindow, -1, "", Point.new(190, 170), Size.new(70, 24), TE_READONLY)
    StaticText.new(@mainwindow, -1, "Size: ", Point.new(20, 200))
    StaticText.new(@mainwindow, -1, "Width: ", Point.new(20, 233))
    @width = TextCtrl.new(@mainwindow, -1, "", Point.new(65, 230), Size.new(70, 24), TE_READONLY)
    StaticText.new(@mainwindow, -1, "Height: ", Point.new(150, 233))
    @height = TextCtrl.new(@mainwindow, -1, "", Point.new(200, 230), Size.new(70, 24), TE_READONLY)
    
    StaticText.new(@mainwindow, -1, "Mouse position: ", Point.new(20, 300))
    StaticText.new(@mainwindow, -1, "X: ", Point.new(20, 333))
    @x = TextCtrl.new(@mainwindow, -1, "", Point.new(60, 330), Size.new(70, 24), TE_READONLY)
    StaticText.new(@mainwindow, -1, "Y: ", Point.new(150, 333))
    @y = TextCtrl.new(@mainwindow, -1, "", Point.new(190, 330), Size.new(70, 24), TE_READONLY)
    
  end
  
  def create_updater
    @updater = InfoGetter.new
    Timer.every(UPDATE_TIME) do
      begin
        @updater.update
        @title.text = @updater.act_win.title
        @id.text = @updater.act_win.id.inspect
        @abs_xy.text = @updater.act_win.abs_position.join(", ")
        @rel_xy.text = @updater.act_win.rel_position.join(", ")
        ary = @updater.act_win.size
        @width.text = ary[0].inspect
        @height.text = ary[1].inspect
      rescue NoMethodError
        puts "Window closed. Skipping NoMethodError. "
        #Das aktive Fenster wird wohl gerade gelöscht. 
        #Daher nichts machen. 
      end
      
      curpos = @updater.cursorpos
      @x.text = curpos[0].inspect
      @y.text = curpos[1].inspect
    end
    
  end
  
end


begin
  puts "Creating GUI"
  x = XInfo.new
  puts "Starting main loop"
  x.main_loop
rescue
  message = "An #{$!.class} occured. Backtrace: \n\n#{$@.join("\n")}"
  message << "\n\nThe error message will be printed in the ~/.xinfo.rb.log file. "
  message << "If you want to contact me about the error, send an email to sutniuq ät gmx Dot net and "
  message << "attach the Err.log file."
  msgbox = Wx::MessageDialog.new(nil, message, $!.class.to_s, OK | ICON_ERROR)
  msgbox.show_modal
  raise #for logging
end
