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
    
    #Executes a mouse click. 
    #===Parameters
    #* x (INTDEFAULT): The X position. The cursor's current X if not specified. 
    #* y (INTDEFAULT): The Y position. The cursor's current Y if not specified. 
    #* button(<tt>"Primary"</tt>): The mouse button to click width. On a mouse for left-handed people the right, for right-handed people the left mouse button. 
    #* clicks(1): The number of times to click. 
    #* speed(10): The speed the mouse cursor will move with. If set to 0, the cursor is set immediatly. 
    #===Return value
    #nil. 
    #===Raises
    #[Au3Error] Invalid mouse button specified. 
    #===Example
    #  #Normal mouse click at (100|100). 
    #  AutoItX3.mouse_click(100, 100)
    #  #Click with the right (or left if buttons are swapped) button
    #  AutoItX3.mouse_click(AutoItX3::INTDEFAULT, AutoItX3::INTDEFAULT, "Secondary")
    #  #Don't move the cursor
    #  AutoItX3.mouse_click(100, 100, "Primary", 1, 0)
    #Clicks the mouse. 
    def mouse_click(x = INTDEFAULT, y = INTDEFAULT, button = "Primary", clicks = 1, speed = 10)
      @functions[__method__] ||= AU3_Function.new("MouseClick", 'SLLLL', 'L')
      @functions[__method__].call(button.wide, x, y, clicks, speed)
      
      raise(Au3Error, "Invalid button '#{button}'!") if last_error == 1
      nil
    end
    
    #Performes a drag & drop operation. 
    #===Parameters
    #[+x1+] The start X coordinate. 
    #[+y1+] The start Y coordinate. 
    #[+x2+] The goal X coordinate. 
    #[+y2+] The goal Y coordinate. 
    #[+button+] The button to hold down while moving. 
    #[+speed+] The cursor's speed. If 0, the cursor is set directly to the goal position. 
    #===Return value
    #nil. 
    #===Raises
    #[Au3Error] Invalid mouse button specified. 
    #===Example
    #  AutoItX3.drag_mouse(10, 10, 73, 86)
    #  #With the secondary mouse button
    #  AutoItX3.drag_mouse(10, 10, 73, 86, "Secondary")
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
    #Holds a mouse button down. 
    #===Parameters
    #[+button+] (<tt>"Primary"</tt>) The button to hold down. 
    #===Return value
    #nil. 
    #===Example
    #  AutoItX3.hold_mouse_down("Primary")
    #  AutoItX3.hold_mouse_down("Secondary")
    #===Remarks
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
    #Get the cursor that is shown at the moment. 
    #===Return value
    #One of the *_CURSOR constants to indicate which cursor icon is actually shown. 
    #===Example
    #  p AutoItX3.cursor_id #=> 5 #IBEAM_CURSOR, that one with the >I< form for editing texts. 
    def cursor_id
      @functions[__method__] ||= AU3_Function.new("MouseGetCursor", '', 'L')
      @functions[__method__].call
    end
    
    #call-seq: 
    #  cursor_pos ==> anArray
    #  get_cursor_pos ==> anArray
    #
    #Returns the current cursor position. 
    #===Return value
    #The current cursor position in a two-element array of form <tt>[x, y]</tt>. 
    #===Example
    #  p AutoItX3.cursor_pos #=> [127, 345]
    def cursor_pos
      @functions[:cursor_pos_x] ||= AU3_Function.new("MouseGetPosX", 'V', 'L')
      @functions[:cursor_pos_y] ||= AU3_Function.new("MouseGetPosY", 'V', 'L')
      [@functions[:cursor_pos_x].call, @functions[:cursor_pos_y].call]
    end
    
    #call-seq: 
    #  move_mouse( x , y [, speed = 10 ] ) ==> nil
    #  mouse_move( x , y [, speed = 10 ] ) ==> nil
    #
    #Moves the mouse cursor to the given position. 
    #===Parameters
    #[+x+] The goal X coordinate. 
    #[+y+] The goal Y coordinate. 
    #[+speed+] (+10+) The speed to move the cursor with. 0 means no movement and the cursor is set directly to the goal position. 
    #===Return value
    #nil. 
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
    #===Parameters
    #[+button+] (<tt>"Primary"</tt>) The mouse button to release. 
    #===Return value
    #nil. 
    #===Example
    #  AutoItX3.hold_mouse_down
    #  AutoItX3.release_mouse
    #  #With the secondary button
    #  AutoItX3.hold_mouse_down("Secondary")
    #  AutoItX3.release_mouse("Secondary")
    def release_mouse(button = "Primary")
      @functions[__method__] ||= AU3_Function.new("MouseUp", 'S')
      @functions[__method__].call(button.wide)
      nil
    end
    
    #Scrolls up or down the mouse wheel. 
    #===Parameters
    #[+direction+] The scrolling direction, either <tt>"up</tt> or <tt>"down</tt>. 
    #[+times+] The scrolling steps. These <b>are not</b> full wheel turns. 
    #===Return value
    #nil. 
    #===Example
    #  #5 steps up. 
    #  AutoItX3.mouse_wheel("up")
    #  #3 steps down. 
    #  AutoItX3.mouse_wheel("down", 3)
    def mouse_wheel(direction, times = 5)
      @functions[__method__] ||= AU3_Function.new("MouseWheel", 'SL')
      @functions[__method__].call(direction.wide, times)
      
      raise(Au3Error, "Undefined mouse wheel direction '#{direction}!") if last_error == 1
      nil
    end
    
  end
  
end