#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module AutoItX3
  
  #Unknown cursor icon
  UNKNOWN_CURSOR = 0
  #Application starting cursor (arrow with a hourglass next to it)
  APP_STARTING_CURSOR = 1
  #The normal cursor
  ARROW_CURSOR = 2
  #Cross cursor
  CROSS_CURSOR = 3
  #Cursor with a question mark next to it
  HELP_CURSOR = 4
  #Cursor for editing lines of text
  IBEAM_CURSOR = 5
  ICON_CURSOR = 6
  #Cursor for forbidden actions (a circle with a strike through it)
  NO_CURSOR = 7
  SIZE_CURSOR = 8
  SIZE_ALL_CURSOR = 9
  SIZE_NESW_CURSOR = 10
  SIZE_NS_CURSOR = 11
  SIZE_NWSE_CURSOR = 12
  SIZE_WE_CURSOR = 13
  UP_ARROW_CURSOR = 14
  #Wait (the well-known "hourglass")
  WAIT_CURSOR = 15
  
  class << self
    
    #====Arguments
    #- x (INTDEFAULT): The X position. The cursor's current X if not specified. 
    #- y (INTDEFAULT): The Y position. The cursor's current Y if not specified. 
    #- button("Primary"): The mouse button to click width. On a mouse for left-handed people the right, for right-handed people the left mouse button. 
    #- clicks(1): The number of times to click. 
    #- speed(10): The speed the mouse cursor will move with. If set to 0, the cursor is set immediatly. 
    #
    #Clicks the mouse. 
    def mouse_click(x = INTDEFAULT, y = INTDEFAULT, button = "Primary", clicks = 1, speed = 10)
      @functions[__method__] ||= AU3_Function.new("MouseClick", 'SLLLL', 'L')
      @functions[__method__].call(button.wide, x, y, clicks, speed)
      
      raise(Au3Error, "Invalid button '#{button}'!") if last_error == 1
      nil
    end
    
    #Performes a drag & drop operation with the given parameters. 
    def drag_mouse(x1, y1, x2, y2, button = "Primary", speed = 10)
      @functions[__method__] ||= AU3_Function.new("MouseClickDrag", 'SLLLLL', 'L')
      @functions[__method__].call(button.wide, x1, y1, x2, y2, speed)
      
      raise(Au3Error, "Invalid button '#{button}'!") if last_error == 1
      nil
    end
    
    #call-seq: 
    #  hold_mouse_down( [ button = "Primary" ] ) ==> nil
    #  mouse_down( [ button = "Primary" ] ) ==> nil
    #
    #Holds a mouse button down (the left by default, or the right if mouse buttons are swapped). 
    #You should release the mouse button somewhen. 
    def hold_mouse_down(button = "Primary")
      @functions[__method__] ||= AU3_Function.new("MouseDown", 'S')
      @functions[__method__].call(button.wide)
      nil
    end
    
    #call-seq: 
    #  cursor_id ==> aFixnum
    #  get_cursor_id ==> aFixnum
    #
    #Returns one of the *_CURSOR constants to indicate which cursor icon is actually shown. 
    def cursor_id
      @functions[__method__] ||= AU3_Function.new("MouseGetCursor", '', 'L')
      @functions[__method__].call
    end
    
    #call-seq: 
    #  cursor_pos ==> anArray
    #  get_cursor_pos ==> anArray
    #
    #Returns the current cursor position in a two-element array of form <tt>[x, y]</tt>. 
    def cursor_pos
      @functions[:cursor_pos_x] ||= AU3_Function.new("MouseGetPosX", '')
      @functions[:cursor_pos_y] ||= AU3_Function.new("MouseGetPosY", '')
      [@functions[:cursor_pos_x].call, @functions[:cursor_pos_y].call]
    end
    
    #call-seq: 
    #  move_mouse( x , y [, speed = 10 ] ) ==> nil
    #  mouse_move( x , y [, speed = 10 ] ) ==> nil
    #
    #Moves the mouse cursor to the given position. If +speed+ is 0, 
    #it's set immediately. 
    def move_mouse(x, y, speed = 10)
      @functions[__method__] ||= AU3_Function.new("MouseMove", 'LLL', 'L')
      @functions[__method__].call(x, y, speed)
      nil
    end
    
    #call-seq: 
    #  release_mouse( [ button = "Primary" ] ) ==> nil
    #  mouse_up( [ button = "Primary" ] ) ==> nil
    #
    #Releases a mouse button hold down by #hold_mouse_down. 
    def release_mouse(button = "Primary")
      @functions[__method__] ||= AU3_Function.new("MouseUp", 'S')
      @functions[__method__].call(button.wide)
      nil
    end
    
    #Scrolls up or down the mouse wheel +times+ times. Use 
    #ether "Up" or "Down" as the value for +direction+. 
    def mouse_wheel(direction, times = 5)
      @functions[__method__] ||= AU3_Function.new("MouseWheel", 'SL')
      @functions[__method__].call(direction.wide, times)
      
      raise(Au3Error, "Undefined mouse wheel direction '#{direction}!") if last_error == 1
      nil
    end
    
  end
  
end