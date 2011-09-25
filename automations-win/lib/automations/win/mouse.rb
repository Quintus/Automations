require_relative "../win"
require_relative "misc"

#This module encapsulates everything you need to interact with
#your mouse cursor.
module Automations::Win::Mouse

  class << self
    include Automations::Win::Utilities
    include Automations::Win::Wrappers
    include Automations::Win

    #call-seq:
    #  position() -> ary
    #  pos()      -> ary
    #
    #Retrieve the current cursor position in pixel coordinates.
    #==Return value
    #An array of form <tt>[x, y]</tt>.
    #==Example
    #  Mouse.position #=> [302, 442]
    def position
      ptr = Structs::Point.new
      Functions.scall(:get_cursor_pos, ptr)
      [ptr[:x], ptr[:y]]
    end
    alias pos position

    #call-seq:
    #  position=(x, y)
    #  pos=(x, y)
    #
    #Set the cursor to the specified position.
    #==Parameters
    #[*ary] The new coordinates as an array of form <tt>[x, y]</tt>.
    #==Example
    #  Mouse.position = [100, 234]
    def position=(ary)
      Functions.scall(:set_cursor_pos, *ary)
    end
    alias pos= position=

    #Moves the mouse to the specified position.
    #==Parameters
    #[target_x] The target X coordinate.
    #[target_y] The target Y coordinate.
    #[relative] (false) If this is true, the +target_x+ and +target_y+ are
    #           interpreted relative to the current cursor position.
    #==Return value
    #The new cursor position as an array of form <tt>[x, y]</tt>.
    #==Examples
    #  # Move the mouse to (100|100)
    #  Mouse.move(100, 100)
    #  
    #  # From there on, move it to (120|200)
    #  Mouse.move(20, 100, true)
    #==Remarks
    #This method isn't absolutely exact, you will notice a slight offset
    #around 2 pixels. If you need absolutely exact coordinates, use
    #the #position= method, but keep in mind that #move uses the
    #more modern <tt>SendInput()</tt> interface.
    def move(target_x, target_y, relative = false)
      input        = Structs::Input.new
      input[:type] = Constants::INPUT_MOUSE
      
      mi            = input[:union][:mi]
      mi[:dw_flags] = Constants::MOUSEEVENTF_MOVE
      if relative
        mi[:dx] = target_x
        mi[:dy] = target_y
      else
        #The following computations are necessary, because an absolute
        #mouse move isn't specified in pixels (whyever). See
        #http://stackoverflow.com/questions/4540282/using-mouse-with-sendinput-in-c
        #for more information on this.
        mi[:dx] = target_x * (Constants::MOUSEFACTOR / Misc.system_metric(:cxscreen))
        mi[:dy] = target_y * (Constants::MOUSEFACTOR / Misc.system_metric(:cyscreen))
        mi[:dw_flags] |= Constants::MOUSEEVENTF_ABSOLUTE
      end
      
      Functions.scall(:send_input, 1, input, Structs::Input.size)
      position
    end

  end

end
