#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
require_relative("../xdo")
module XDo
  
  #Automate your mouse! You can simulate every click you can do with 
  #your fingers - it's kind of funny, but don't forget to create USEFUL 
  #applications, not ones annoying your users (e. g. you could make 
  #his/her mouse unusable). 
  module Mouse
    
    #Left mouse button. 
    LEFT = 1
    #Middle mouse button (as if you click your mouse wheel). 
    MIDDLE = 2
    #Right mouse button. 
    RIGHT = 3
    #Mouse wheel up. 
    UP = 4
    #Mouse wheel down. 
    DOWN = 5
    
    #Maps the button's symbols to the numbers xdotool uses. 
    BUTTON2XDOTOOL = {
      :left => 1, 
      :middle => 2, 
      :right => 3, 
      :up => 4, 
      :down => 5
    }.freeze
    
    class << self
      
      #Gets the current cursor position. 
      #===Return value
      #A two-element array of form <code>[x, y]</code>. 
      #===Example
      #  p XDo::Mouse.position #=> [12, 326]
      def position
        out = `#{XDOTOOL} getmouselocation`.match(/x:(\d+) y:(\d+)/)
        [$1.to_i, $2.to_i]
      end
      
      #Moves the mouse cursor to the given position. 
      #===Parameters
      #[+x+] The goal X coordinate. 
      #[+x+] The goal Y coordinate. 
      #[+speed+] (2) Cursor move speed, in pixels per iteration. The higher the value, the more inaccurate the movement (but you can be sure the cursor is always at the position you specified at the end). 
      #[+set+] (false) If true, the +speed+ parameter is ignored and the cursor is directly set to the given position. 
      #===Return value
      #The position you specified, as a two-dimensional array of form <tt>[x, y]</tt>. 
      #===Raises
      #[ArgumentError] The value of +speed+ was lower or equal to zero. 
      #===Example
      #  #Move to (10|10)
      #  XDo::Mouse.move(10, 10)
      #  #Move fast to (10|10)
      #  XDo::Mouse.move(10, 10, 10)
      #  #Directly set the cursor to (10|10) without any movement
      #  XDo::Mouse.move(10, 10, 1, true)
      def move(x, y, speed = 2, set = false)
        if set
          `#{XDOTOOL} mousemove #{x} #{y}`
          return [x, y]
        else
          raise(ArgumentError, "speed has to be > 0 (default is 2), was #{speed}!") if speed <= 0
          pos = position #Current cursor position
          act_x = pos[0]
          act_y = pos[1]
          aim_x = x
          aim_y = y
          #Create the illusion of a fluent movement (hey, that statement sounds better in German, really! ;-))
          loop do
            #Change position as indiciated by +speed+
            if act_x > aim_x
              act_x -= speed
            elsif act_x < aim_x
              act_x += speed
            end
            if act_y > aim_y
              act_y -= speed
            elsif act_y < aim_y
              act_y += speed
            end
            #Move to computed position
            move(act_x, act_y, speed, true)
            #Check wheather the cursor's current position is inside an 
            #acceptable area around the goal position. The size of this 
            #area is defined by +speed+; this check ensures we don't get 
            #an infinite loop for unusual conditions. 
            if ((aim_x - speed)..(aim_x + speed)).include? act_x
              if ((aim_y - speed)..(aim_y + speed)).include? act_y
                break
              end #if in Y-Toleranz
            end #if in X-Toleranz
          end #loop
          #Correct the cursor position to point to the exact point specified. 
          #This is for the case the "acceptable area" condition above triggers. 
          if position != [x, y]
            move(x, y, 1, true)
          end #if position != [x, y]
          
        end #if set
        [x, y]
      end #def move
      
      #Simulates a mouse click. If you don't specify a X AND a Y position, 
      #the click will happen at the current cursor position. 
      #===Parameters
      #[+x+] (nil) The goal X position. Specify together with +y+. 
      #[+y+] (nil) The goal Y position. 
      #[+button+] (:left) The button to click with. One of the following symbols: <tt>:left</tt>, <tt>:right</tt>, <tt>:middle</tt>. 
      #The other arguments are the same as for #move. 
      #===Return value
      #Undefined. 
      #===Example
      #  #Click at the current position
      #  XDo::Mouse.click
      #  #Click at (10|10)
      #  XDo::Mouse.click(10, 10)
      #  #Click at the current position with the right mouse button
      #  XDo::Mouse.click(nil, nil, :right)
      #  #Move fast to (10|10) and click with the right mouse button
      #  XDo::Mouse.click(10, 10, :right, 10)
      #  #Directly set the cursor to (10|10) and click with the middle mouse button
      #  XDo::Mouse.click(10, 10, :middle, 1, true)
      def click(x = nil, y = nil, button = :left, speed = 1, set = false)
        if button.kind_of?(Numeric)
          warn("#{caller.first}: Deprecation warning: Use symbols such as :left for the button parameter.")
          button = BUTTON2XDOTOOL.keys[button - 1] #indices are 0-based
        end
        if x and y
          move(x, y, speed, set)
        end
        `#{XDOTOOL} click #{BUTTON2XDOTOOL[button]}`
      end
      
      #Scroll with the mouse wheel. +amount+ is the time of steps to scroll. 
      #Note: The XServer handles wheel up and wheel down events like mouse click 
      #events and if you take a look in the source code of this function you will see, that 
      #it calls #click with the value of UP or DOWN. So, if you want to be funny, write something 
      #like 
      #  XDo::Mouse.click(nil, nil, XDo::Mouse::UP)
      #. 
      def wheel(dir, amount)
        amount.times{click(nil, nil, dir)}
      end
      
      #Holds a mouse button down. Don't forget to release it some time. 
      def down(button = LEFT)
        `#{XDOTOOL} mousedown #{button}`
      end
      
      #Releases a mouse button. You should call #down before using this...
      def up(button = LEFT)
        `#{XDOTOOL} mouseup #{button}`
      end
      
      #Executs a drag&drop operation. If you set +x1+ and +y1+ to nil, 
      #this method will use the current cursor position as the start position. 
      def drag(x1, y1, x2, y2, button = LEFT, speed = 2, set = false)
        #Wenn x1 und y1 nicht übergeben werden, nehme die aktuelle Positin an
        if x1.nil? and y1.nil?
          x1, y1 = position
        end
        #Zur angegebenen Erstposition bewegen
        move(x1, y1, speed, set)
        #Taste gedrückt halten
        down(button)
        #Zur Zielposition bewegen
        move(x2, y2, speed, set)
        #Taste loslassen
        up(button)
        nil
      end
      
    end #class << self
    
  end #module Mouse
end