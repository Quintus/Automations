#!/usr/bin/env ruby
#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009, 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
require_relative("../xdo")
require_relative("./keyboard")

module XDo
  
  #Mixin that allows String-like objects to be directly 
  #simulated. You can use it with Ruby's String class: 
  #  require "xdo/simulatable"
  #  
  #  class String
  #    include XDo::Simulatable
  #    def to_xdo
  #      to_s
  #    end
  #  end
  #
  #  "abc".simulate
  #Every method in this module calls #to_xdo on +self+ 
  #first, so make sure this method returns a xdo-usable 
  #String (i.e. no invisible characters except newline, tab and space). 
  module Simulatable
    
    #Simulates +self+ as keystrokes. Escape sequences are allowed. 
    #===Parameters
    #[raw] (+false+) If true, escape sequences are ignored. 
    #[w_id] (+nil+) The window's ID to send the keystrokes to. Either an integer or a XWindow object. 
    #===Return value
    #self.
    #===Raises
    #[ParseError] Your string was invalid. 
    #===Example
    #  "This is an{BS} test".simulate
    #  win = XDo::XWindow.from_title(/gedit/)
    #  "This is an{BS} test".simulate(false, win)
    def simulate(raw = false, w_id = nil)
      XDo::Keyboard.simulate(to_xdo, raw, w_id)
    end
    
    #Types +self+ as keystrokes. Ignores escape sequences. 
    #===Parameters
    #[w_id] The window's ID to send the keystrokes to. Either an integer or a XWindow object. 
    #===Return value
    #nil. 
    #===Example
    #  "Some test text".type
    #  win = XDo::XWindow.from_title(/gedit/)
    #  "Some test text".type(win)
    def type(w_id = nil)
      XDo::Keyboard.type(to_xdo, w_id)
    end
    
    #Holds the the key corresponding to the first character in +self+ down. 
    #===Parameters
    #[w_id] The window in which to hold a key down. Either an integer ID or a XWindow object. 
    #===Return value
    #The character of the key hold down. 
    #===Raises
    #[XError] Invalid keyname.
    #===Example
    #  "a".down
    #  win = XDo::XWindow.from_title(/gedit/)
    #  "a".down(win)
    def down(w_id = nil)
      XDo::Keyboard.key_down(to_xdo[0], w_id)
    end
    
    #Releases the key corresponding to the first character in +self+. 
    #===Parameters
    #[w_id] The window in which to release a key. Either an integer ID or a XWindow object. 
    #===Return value
    #The character of the key released. 
    #===Raises
    #[XError] Invalid keyname. 
    #===Example
    #  "a".up
    #  win = XDo::XWindow.from_title(/gedit/)
    #  "a".up(win)
    def up(w_id = nil)
      XDo::Keyboard.key_up(to_xdo[0], w_id)
    end
    
  end
  
end