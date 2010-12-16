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
    
  end
  
end

require_relative "./x11/keyboard"
require_relative "./x11/mouse"
