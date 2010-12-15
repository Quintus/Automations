#!/usr/bin/env ruby
#Encoding: UTF-8
#This file is part of Automations. 
#Copyright © 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 

#Things specific to the X11 part, but needed by the 
#whole part. 
module Automations
  
  module X11
   
    #The command to start xdotool. 
    XDOTOOL = "xdotool"
    
    #The command to start xsel. 
    XSEL = "xsel"
    
    #The command to start xwininfo. 
    XWININFO = "xwininfo"
    
    #The command to start xkill. 
    XKILL = "xkill"
    
    #The command to start eject. 
    EJECT = "eject"
    
    #Class for errors in the X11 library. 
    class XError < StandardError
    end
    
    class ParseError < StandardError
    end
    
  end
  
end

require_relative "./linux/clipboard"
require_relative "./linux/drive"
require_relative "./linux/keyboard"
require_relative "./linux/mouse"
require_relative "./linux/simulatable"
require_relative "./linux/xwindow"