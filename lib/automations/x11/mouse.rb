#Encoding: UTF-8
#This file is part of Xdo.
#Copyright © 2009 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat.

module Automations
  
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
        #[+sync+] (true) If true, this method blocks until the cursor has reached the given position.
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
        def move(x, y, speed = 2, set = false, sync = true)
          if set
            opts = []
            opts << "--sync" if sync
            `#{XDOTOOL} mousemove #{opts.join(" ")} #{x} #{y}`
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
        #===Parameters
        #[+dir+] The direction to scroll into. Either :up or :down.
        #[+amount+] The number of steps to scroll. These are *not* meant to be full wheel rounds.
        #===Return value
        #Undefined.
        #===Example
        #  #Scroll up
        #  XDo::Mouse.wheel(:up, 4)
        #  #Scroll down 4 steps
        #  XDo::Mouse.wheel(:down, 4)
        #===Remarks
        #The X Server handles wheel up and wheel down events like mouse click
        #events and if you take a look in the source code of this function you will see, that
        #it calls #click passing through the +dir+ parameter. So, if you want to be funny,
        #write something like
        #  XDo::Mouse.click(nil, nil, :up)
        #.
        def wheel(dir, amount)
          if button.kind_of?(Numeric)
            warn("#{caller.first}: Deprecation warning: Use symbols such as :up for the dir parameter.")
            button = BUTTON2XDOTOOL.keys[button - 1] #indices are 0-based
          end
          amount.times{click(nil, nil, dir)}
        end
      
        #Holds a mouse button down. Don't forget to release it some time.
        #===Parameters
        #[+button+] (:left) The button to hold down.
        #===Return value
        #Undefined.
        #===Example
        #  #Hold down the left mouse button for a second
        #  XDo::Mouse.down
        #  sleep 1
        #  XDo::Mouse.up
        #  #Hold down the right mouse button for a second
        #  XDo::Mouse.down(:right)
        #  sleep 1
        #  XDo::Mouse.up(:right)
        def down(button = :left)
          if button.kind_of?(Numeric)
            warn("#{caller.first}: Deprecation warning: Use symbols such as :left for the button parameter.")
            button = BUTTON2XDOTOOL.keys[button - 1] #indices are 0-based
          end
          `#{XDOTOOL} mousedown #{BUTTON2XDOTOOL[button]}`
        end
      
        #Releases a mouse button. Probably it's a good idea to call #down first?
        #===Parameters
        #[+button+] (:left) The button to release.
        #===Return value
        #Undefined.
        #===Example
        #  #Hold down the left mouse button for a second
        #  XDo::Mouse.down
        #  sleep 1
        #  XDo::Mouse.up
        #  #Hold down the right mouse button for a second
        #  XDo::Mouse.down(:right)
        #  sleep 1
        #  XDo::Mouse.up(:right)
        def up(button = :left)
          if button.kind_of?(Numeric)
            warn("#{caller.first}: Deprecation warning: Use symbols such as :left for the button parameter.")
            button = BUTTON2XDOTOOL.keys[button - 1] #indices are 0-based
          end
          `#{XDOTOOL} mouseup #{BUTTON2XDOTOOL[button]}`
        end
      
        #Executs a drag&drop operation.
        #===Parameters
        #[+x1+] Start X coordinate. Set to the current cursor X coordinate if set to nil. Pass together with +y1+.
        #[+y1+] Start Y coordinate. Set to the current cursor Y coordinate if set to nil.
        #[+x2+] Goal X coordinate.
        #[+y2+] Goal Y coordinate.
        #[+button+] (:left) The button to hold down.
        #The rest of the parameters is the same as for #move.
        #===Return value
        #nil.
        #===Example
        #  #Drag from (10|10) to (37|56)
        #  XDo::Mouse.drag(10, 10, 37, 56)
        #  #Drag from (10|10) to (37|56) holding the right mouse button down
        #  XDo::Mouse.drag(10, 10, 37, 56, :right)
        def drag(x1, y1, x2, y2, button = :left, speed = 2, set = false)
          if button.kind_of?(Numeric)
            warn("#{caller.first}: Deprecation warning: Use symbols such as :left for the button parameter.")
            button = BUTTON2XDOTOOL.keys[button - 1] #indices are 0-based
          end
          #If x1 and y1 aren't passed, assume the current position
          if x1.nil? and y1.nil?
            x1, y1 = position
          end
          #Go to the given start position
          move(x1, y1, speed, set)
          #Hold button down
          down(button)
          #Move to the goal position
          move(x2, y2, speed, set)
          #Release button
          up(button)
          nil
        end
      
      end #class << self
          
  end
  
end
