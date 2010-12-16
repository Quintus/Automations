#!/bin/env ruby
#Encoding: UTF-8

module Automations
  
  module Mouse
    
    #Shortcut for Automations::Au3::Functions
    Functions = Au3::Functions
    
    class << self
      
      def position
        [Functions.mouse_get_pos_x(), Functions.mouse_get_pos_y()]
      end
      
      def move(x, y, speed = nil, set = false)
        if set
          Functions.mouse_move(x, y, 0)
        else
          if speed.nil?
            speed = -1 #Default value of AutoIt
          else
            raise(ArgumentError, "speed has to be in the range 0 < speed < 101!") unless (1..100).include?(speed)
            speed = 101 - speed #For AutoIt, 100 is slowest and 1 fastest, but for us it's exactly reversed
          end
          Functions.mouse_move(x, y, speed)
        end
        [x, y]
      end
      
      def click(x, y, button = :left, clicks = 1, speed = nil, set = false)
        if set
          Functions.mouse_click(Au3.wide_str(button.to_s.capitalize), x, y, clicks, 0)
        else          
          if speed.nil?
            speed = -1 #Default value of AutoIt
          else
            raise(ArgumentError, "speed has to be in the range 0 < speed < 101!") unless (1..100).include?(speed)
            speed = 101 - speed #For AutoIt, 100 is slowest and 1 fastest, but for us it's exactly reversed
          end
          Functions.mouse_click(Au3.wide_str(button.to_s.capitalize), x, y, clicks, 0)
        end
        [x, y]
      end
      
    end
    
  end
  
end