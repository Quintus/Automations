#!/usr/bin/env ruby
#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009, 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
#
#This program displays information about the currently selected window 
#and the mouse. The displayed infos are updated every 1/2 second, 
#but set XInfo::UPDATE_TIME to another value if you'd like to change that. 

require "logger"
require "wx"

require_relative("../lib/xdo/xwindow")
require_relative("../lib/xdo/mouse")

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

class XInfoFrame < Wx::Frame
  include Wx
  
  #Time intervall of updating the infos, in milliseconds. 
  #Default is 500, which is 1/2 second. 
  UPDATE_TIME = 500
  
  def initialize(parent = nil)
    super(parent, title: "XInfo", size: Size.new(300, 400), style: DEFAULT_FRAME_STYLE | STAY_ON_TOP)
    self.background_colour = NULL_COLOUR
    THE_APP.log.debug("Creating controls")
    create_controls
    THE_APP.log.debug("Setting up timer")
    create_updater
  end
  
  private
  
  def create_controls
    StaticText.new(self, -1, "Title of active window: ", Point.new(20, 20))
    @title = TextCtrl.new(self, pos: Point.new(20, 50), size: Size.new(260, 24), style: TE_READONLY)
    StaticText.new(self, -1, "ID of active window: ", Point.new(20, 80))
    @id = TextCtrl.new(self, -1, "", Point.new(20, 110), Size.new(260, 24), TE_READONLY)
    StaticText.new(self, -1, "Absoloute and relative upper-left coords: ", Point.new(20,140))
    StaticText.new(self, -1, "Abs: ", Point.new(20, 173))
    @abs_xy = TextCtrl.new(self, -1, "", Point.new(60, 170), Size.new(70, 24), TE_READONLY)
    StaticText.new(self, -1, "Rel: ", Point.new(150, 173))
    @rel_xy = TextCtrl.new(self, -1, "", Point.new(190, 170), Size.new(70, 24), TE_READONLY)
    StaticText.new(self, -1, "Size: ", Point.new(20, 200))
    StaticText.new(self, -1, "Width: ", Point.new(20, 233))
    @width = TextCtrl.new(self, -1, "", Point.new(65, 230), Size.new(70, 24), TE_READONLY)
    StaticText.new(self, -1, "Height: ", Point.new(150, 233))
    @height = TextCtrl.new(self, -1, "", Point.new(200, 230), Size.new(70, 24), TE_READONLY)
    
    StaticText.new(self, -1, "Mouse position: ", Point.new(20, 300))
    StaticText.new(self, -1, "X: ", Point.new(20, 333))
    @x = TextCtrl.new(self, -1, "", Point.new(60, 330), Size.new(70, 24), TE_READONLY)
    StaticText.new(self, -1, "Y: ", Point.new(150, 333))
    @y = TextCtrl.new(self, -1, "", Point.new(190, 330), Size.new(70, 24), TE_READONLY)
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
      rescue NoMethodError #This means the active window is being closed. 
        THE_APP.log.warn "Window closed. Skipping NoMethodError. "        
      end
      
      curpos = @updater.cursorpos
      @x.text = curpos[0].inspect
      @y.text = curpos[1].inspect
    end
  end
  
end

#Main App object of this program. 
class XInfo < Wx::App
  include Wx
  
  #Logger. 
  attr_reader :log  
  
  def on_init
    @log = Logger.new($stdout)
    @log.level = Logger::INFO unless $VERBOSE || $DEBUG
    @log.info("Started")
    @log.debug "Creating main window"
    @mainwindow = XInfoFrame.new    
    @mainwindow.show
  end
  
  def on_run
    super
  rescue => e
    @log.fatal(e.class.name)
    e.backtrace.each{|trace| @log.fatal(trace)}
    message = "A #{e.class} occured. Backtrace: \n\n#{e.backtrace.join("\n")}"    
    message << "\n\nIf you want to contact me about the error, send an email to sutniuq ät gmx Dot net."    
    msgbox = MessageDialog.new(@mainwindow, message, $!.class.name, OK | ICON_ERROR)
    msgbox.show_modal
    raise
  end
  
  def on_exit
    super
    @log.info("Finished.")
  end
  
end

if ARGV.include?("-h") or ARGV.include?("--help")
  puts "xinfo.rb doesn't understand many command-line options."
  puts "There's -h for this message, -V for verbose output"
  puts "and -d for debugging."
  exit
end

$VERBOSE = true if ARGV.include?("-V")
$DEBUG = true if ARGV.include?("-d")

x = XInfo.new  
x.main_loop