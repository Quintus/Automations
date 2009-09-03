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
    
    class << self
      
      #Gets the current cursor position, which is returned as a two-element array 
      #of form <code>[x, y]</code>. 
      def position
        cmd = "#{XDOTOOL} getmouselocation"
        out = `#{cmd}`
        out.match(/x:(\d+) y:(\d+)/)
        return [$1.to_i, $2.to_i]
      end
      
      #Moves the mouse cursor to the given position. 
      #If +set+ is true, this function does not move it, but set it directly 
      #to the position. 
      #You can manipulate the speed of the cursor movement by changing 
      #the value of speed (which is 2 pixel per time by default), but the higher 
      #the value is, the more inaccurate the movement is. Tough, the cursor will 
      #be at the specfied position in any case, regeardless of how you set +speed+. 
      def move(x, y, speed = 2, set = false)
        if set
          out = `#{XDOTOOL} mousemove #{x} #{y}`
          return [x, y]
        else
          raise(ArgumentError, "speed has to be > 0 (default is 2), was #{speed}!") if speed <= 0
          pos = position #Aktuelle Cursorposition
          act_x = pos[0]
          act_y = pos[1]
          aim_x = x
          aim_y = y
          #Erschaffe die Illusion einer flüssigen Bewegung
          loop do
            #Position um speed verändern
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
            #Cursor an neue Position setzen
            move(act_x, act_y, speed, true)
            #Prüfen, ob sich die aktuelle Position im durch speed definierten 
            #Toleranzbereich um den Zielpunkt befindet
            if ((aim_x - speed)..(aim_x + speed)).include? act_x
              if ((aim_y - speed)..(aim_y + speed)).include? act_y
                break
              end #if in Y-Toleranz
            end #if in X-Toleranz
          end #loop
          #Falls der Cursor nicht genau auf dem Zielpunkt landet, muss
          #eine Korrektur erfolgen
          if position != [x, y]
            move(x, y, 1, true)
          end #if position != [x, y]
          
        end #if set
        return [x, y]
      end #def move
      
      #Simulates a mouse click. If you don't specify a X AND a Y position, 
      #the click will happen at the current cursor position, +button+ may be one of 
      #the follwoing constants: 
      #* LEFT
      #* RIGHT
      #* MIDDLE
      #The other arguments are the same as for #move. 
      def click(x = nil, y = nil, button = LEFT, speed = 1, set = false)
        if x and y
          move(x, y, speed, set)
        end
        `#{XDOTOOL} click #{button}`
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