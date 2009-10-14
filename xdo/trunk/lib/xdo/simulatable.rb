#!/usr/bin/env ruby
#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009 Marvin Gülker
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
  #Every method in this module calls ##to_xdo on +self+ 
  #first, so make sure this method returns a xdo-usable 
  #String (i.e. no invisible characters except newline, tab and space). 
  module Simulatable
    
    #Simulates +self+ as keystrokes. Escape sequences are allowed. 
    def simulate(raw = false, w_id = nil)
      XDo::Keyboard.simulate(to_xdo, raw, w_id)
    end
    
    #Types +self+ as keystrokes. Ignores escape sequences. 
    def type(w_id = nil)
      XDo::Keyboard.type(to_xdo, w_id)
    end
    
    #Holds the first key of +self+ down. 
    def down(w_id = nil)
      XDo::Keyboard.key_down(to_xdo[0], w_id)
    end
    
    #Releases the first key of +self+ if it's hold 
    #down by #down. 
    def up(w_id = nil)
      XDo::Keyboard.key_up(to_xdo[0], w_id)
    end
    
  end
  
end