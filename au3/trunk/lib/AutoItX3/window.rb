#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module AutoItX3
  
  #A Window object holds a (pseudo) reference to a 
  #window that may be shown on the screen or not. 
  #If you want to get a real handle to the window, 
  #call #handle on your Window object (but you won't 
  #need that unless you want to use it for Win32 API calls). 
  class Window
    
    #A window describing the desktop. 
    DESKTOP_WINDOW = "Program Manager"
    #A window describing the active (foreground) window. 
    ACTIVE_WINDOW = ""
    #Hide the window. 
    SW_HIDE = 0
    #Show the window. 
    SW_SHOW = 5
    #Minimize the window. 
    SW_MINIMIZE = 6
    #Maximize the window. 
    SW_MAXIMIZE = 3
    #Restore a minimized window. 
    SW_RESTORE = 9
    #Uses the default SW_ value of the application. 
    SW_SHOWDEFAULT = 10
    #Same as SW_MINIMIZE, but doesn't activate the window.
    SW_SHOWMINNOACTIVE = 7
    #Same as SW_SHOW, but doesn't activate the window. 
    SW_SHOWNA = 8
    
    @functions = {}
    
    class << self
      
      def functions
        @functions
      end
      
      def functions=(hsh)
        @functions = hsh
      end
      
      #Checks if a window with the given properties exists. 
      def exists?(title, text = "")
        @functions[__method__] ||= AU3_Function.new("WinExists", 'SS', 'L')
        if @functions[__method__].call(title.wide, text.wide) == 0
          return false;
        else
          return true;
        end
      end
      
      #Returns a two-element array of form <tt>[x , y]</tt> reflecting the 
      #position of the caret in the active window. This doesn't work with 
      #every window. 
      def caret_pos
        @functions[:caret_pos_x] ||= AU3_Function.new("WinGetCaretPosX", '', 'L')
        @functions[:caret_pos_y] ||= AU3_Function.new("WinGetCaretPosY", '', 'L')
        pos = [@functions[:caret_pos_x].call, @functions[:caret_pos_y].call]
        raise(Au3Error, "Unknown error occured while retrieving caret coordinates!") if AutoItX3.last_error == 1
        pos
      end
      
      #Minimizes all available windows. 
      def minimize_all
        @functions[__method__] ||= AU3_Function.new("WinMinimizeAll", '')
        @functions[__method__].call
        nil
      end
      
      #Undoes a previous call to Window.minimize_all. 
      def undo_minimize_all
        @functions[__method__] ||= AU3_Function.new("WinMinimizeAllUndo", '')
        @functions[__method__].call
        nil
      end
      
      #Waits for a window with the given properties to exist. You may 
      #specify a +timeout+ in seconds. +wait+ normally returns true, but if 
      #the timeout is expired, it returns false. 
      def wait(title, text = "", timeout = 0)
        @functions[__method__] ||= AU3_Function.new("WinWait", 'SSL', 'L')
        @functions[__method__].call(title.wide, text.wide, timeout) != 0
      end
      
    end
    
    #Creates a new Window object. This method checks if a window 
    #with the given properties exists (via Window.exists?) and raises 
    #an Au3Error if it does not. Use Window::DESKTOP_WINDOW as 
    #the +title+ to get a window describing the desktop. Use Window::ACTIVE_WINDOW 
    #as the +title+ to get a window describing the active (foreground) window. 
    def initialize(title, text = "")
      @title = title
      @text = text
      raise(Au3Error, "Can't get a handle to a non-existing window!") unless Window.exists?(@title, @text)
    end
    
    #Human-readable output of form <tt>"<Window: WINDOW_TITLE (WINDOW_HANDLE)>"</tt>. 
    #The title is determined by calling #title. 
    def inspect
      "<Window: #{title} (#{handle})>"
    end
    
    #Returns +self+'s title by returning the value of @title. 
    def to_s
      @title
    end
    
    #Returns the handle of the window as an integer by calling 
    #<tt>.to_i(16)</tt> on the result of #handle. 
    def to_i
      handle.to_i(16)
    end
    
    #Activates the window and returns true if it was successfully activated (using #active? to check). 
    def activate
      Window.functions[__method__] ||= AU3_Function.new("WinActivate", 'SS')
      Window.functions[__method__].call(@title.wide, @text.wide)
      active?
    end
    
    #Checks wheather or not the window is active. 
    def active?
      Window.functions[__method__] ||= AU3_Function.new("WinActive", 'SS', 'L')
      if Window.functions[__method__].call(@title.wide, @text.wide) == 0
        return false
      else
        return true
      end
    end
    
    #Sends WM_CLOSE to +self+. WM_CLOSE may be processed by the window, 
    #it could, for example, ask to save or the like. If you want to kill a window 
    #without giving the ability to process your message, use the #kill method. 
    def close
      Window.functions[__method__] ||= AU3_Function.new("WinClose", 'SS', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide)
      nil
    end
    
    #call-seq: 
    #  exists? ==> true or false
    #  valid? ==> true or false
    #
    #Calls the Window.exists? class method with the values given in Window.new. 
    def exists?
      Window.exists?(@title, @text)
    end
    alias valid? exists?
    
    #*Returns an array of all used window classes of +self+. 
    def class_list
      Window.functions[__method__] ||= AU3_Function.new("WinGetClassList", 'SSPI')
      buffer = " " * AutoItX3::BUFFER_SIZE
      buffer.wide!
      Window.functions[__method__].call(@title.wide, @text.wide, buffer, AutoItX3::BUFFER_SIZE - 1)
      raise_unfound if AutoItX3.last_error == 1
      buffer.normal.split("\n").map{|str| str.strip.empty? ? nil : str.strip}.compact
    end
    
    #Returns the client area size of +self+ as a two-element array of 
    #form <tt>[ width , height ]</tt>. Returns <tt>[0, 0]</tt> on minimized 
    #windows. 
    def client_size
      Window.functions[:client_size_width] ||= AU3_Function.new("WinGetClientSizeWidth", 'SS', 'L')
      Window.functions[:client_size_height] ||= AU3_Function.new("WinGetClientSizeHeight", 'SS', 'L')
      size = [Window.functions[:client_size_width].call, Window.functions[:client_size_height].call]
      raise_unfound if AutoItX3.last_error == 1
      size
    end
    
    #Returns the numeric handle of a window as a string. It can be used 
    #with the WinTitleMatchMode option set to advanced or for direct calls 
    #to the windows API (but you have to call <tt>.to_i(16)</tt> on the string then). 
    def handle
      Window.functions[__method__] ||= AU3_Function.new("WinGetHandle", 'SSPI')
      buffer = " " * AutoItX3::BUFFER_SIZE
      buffer.wide!
      Window.functions[__method__].call(@title.wide, @text.wide, buffer, AutoItX3::BUFFER_SIZE - 1)
      raise_unfound if AutoItX3.last_error == 1
      buffer.normal.strip
    end
    
    #Returns the position and size of +self+ in a four-element array 
    #of form <tt>[x, y, width, height]</tt>. 
    def rect
      Window.functions[:xpos] ||= AU3_Function.new("WinGetPosX", 'SS', 'L')
      Window.functions[:ypos] ||= AU3_Function.new("WinGetPosY", 'SS', 'L')
      Window.functions[:width] ||= AU3_Function.new("WinGetPosWidth", 'SS', 'L')
      Window.functions[:height] ||= AU3_Function.new("WinGetPosHeight", 'SS', 'L')
      
      title = @title.wide
      text = @text.wide
      
      rect = [
        Window.functions[:xpos].call(title, text), 
        Window.functions[:ypos].call(title, text), 
        Window.functions[:width].call(title, text), 
        Window.functions[:height].call(title, text)
      ]
      raise_unfound if AutoItX3.last_error == 1
      rect
    end
    
    #Returns the process identification number of +self+'s window 
    #procedure. 
    def pid
      Window.functions[__method__] ||= AU3_Function.new("WinGetProcess", 'SSPI', 'L')
      buffer = " " * AutoItX3::BUFFER_SIZE
      buffer.wide!
      Window.functions[__method__].call(@title.wide, @text.wide, buffer, AutoItX3::BUFFER_SIZE - 1)
      buffer.normal!
      buffer.strip!
      if buffer.empty?
        raise(Au3Error, "Unknown error occured while retrieving process ID. Does the window exist?")
      else
        buffer.to_i
      end
    end
    
    #Returns the integer composition of the states 
    #- exists (1)
    #- visible (2)
    #- enabled (4)
    #- active (8)
    #- minimized (16)
    #- maximized (32)
    #Use the bit-wise AND operator & to check for a specific state. 
    #Or just use one of the predefined methods #exists?, #visible?, 
    ##enabled?, #active?, #minimized? and #maximized?. 
    def state
      Window.functions[__method__] ||= AU3_Function.new("WinGetState", 'SS', 'L')
      state = Window.functions[__method__].call(@title.wide, @text.wide)
      raise_unfound if AutoItX3.last_error == 1
      state
    end
    
    #Returns true if +self+ is shown on the screen. 
    def visible?
      (state & 2) == 2
    end
    
    #Returns true if +self+ is enabled (i.e. it can receive input). 
    def enabled?
      (state & 4) == 4
    end
    
    #Returns true if +self+ is minimized to the taskbar. 
    def minimized?
      (state & 16) == 16
    end
    
    #Returns true if +self+ is maximized to full screen size. 
    def maximized?
      (state & 32) == 32
    end
    
    #Returns the text read from a window. This method doesn't query the @text instance 
    #variable, rather it calls the AU3_WinGetText function. 
    def text
      Window.functions[__method__] ||= AU3_Function.new("WinGetText", 'SSPI')
      buffer = " " * AutoItX3::BUFFER_SIZE
      buffer.wide!
      Window.functions[__method__].call(@title.wide, @text.wide, buffer, AutoItX3::BUFFER_SIZE - 1)
      buffer.normal.strip
    end
    
    #Returns the title read from a window. This method does not 
    #affect or even use the value of @title, that means you can use 
    #+title+ to retrieve titles from a window if you're working with the 
    #advanced window mode. 
    def title
      Window.functions[__method__] ||= AU3_Function.new("WinGetTitle", 'SSPI')
      buffer = " " * AutoItX3::BUFFER_SIZE
      buffer.wide!
      Window.functions[__method__].call(@title.wide, @text.wide, buffer, AutoItX3::BUFFER_SIZE - 1)
      buffer.normal.strip
    end
    
    #Kills +self+. This method forces a window to close if it doesn't close 
    #quickly enough (in contrary to #close which waits for user actions 
    #if neccessary). Some windows cannot be +kill+ed (notably 
    #Windows Explorer windows). 
    def kill
      Window.functions[__method__] ||= AU3_Function.new("WinKill", 'SS', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide)
      nil
    end
    
    #Clicks the specified item in the specified menu. You may specify up to seven 
    #submenus. 
    def select_menu_item(menu, *items)
      Window.functons[__method__] ||= AU3_Function.new("WinMenuSelectItem", 'SSSSSSSSSS', 'L')
      raise(ArgumentError, "Wrong number of arguments, maximum is seven items!") if items.size > 7 #(menu is the 8th)
      result = Window.functions[__method__].call(@title.wide, @text.wide, menu.wide, *items.map{|item| item.wide})
      raise_unfound if result == 0
      nil
    end
    
    #Moves a window (and optionally resizes it). This does not work 
    #with minimized windows. 
    def move(x, y, width = -1, height = -1)
      Window.functions[__method__] ||= AU3_Function.new("WinMove", 'SSLLLL', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide, x, y, width, height)
      nil
    end
    
    #Turn the TOPMOST flag of +self+ on or off. If activated, the window 
    #will stay on top above all other windows.
    def set_on_top=(val)
      Window.functions[__method__] ||= AU3_Function.new("WinSetOnTop", 'SSL', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide, !!val)
      val
    end
    
    #Sets +self+'s window state to one of the SW_* constants. 
    def state=(val)
      Window.functions[__method__] ||= AU3_Function.new("WinSetState", 'SSL', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide, val)
      val
    end
    
    #Renames +self+. This does not change the internal @title 
    #instance variable, so you can use this with the 
    #advanced window mode. 
    def title=(val)
      Window.functions[__method__] ||= AU3_Function.new("WinSetTitle", 'SSS', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide, val.wide)
      val
    end
    
    #call-seq: 
    #  AutoItX3::Window#trans = val ==> val
    #  AutoItX3::Window#transparency = val ==> val
    #
    #Sets the transparency of +self+ or raises a NotImplementedError 
    #if the OS is Windows Millenium or older. 
    def trans=(val)
      Window.functions[__method__] ||= AU3_Function.new("WinSetTrans", 'SSL', 'L')
      if Window.functions[__method__].call(@title.wide, @text.wide, val) == 0
        raise(NotImplementedError, "The method trans= is only implemented in Win2000 and newer!")
      end
      val
    end
    alias transparency= trans=
    
    #Waits for +self+ to exist. This method calls Window's class 
    #method wait, so see Window.wait for more information. 
    def wait(timeout = 0)
      Window.wait(@title, @text, timeout)
    end
    
    #Waits for +self+ to be the active (that is, get the input focus). 
    def wait_active(timeout = 0)
      Window.functions[__method__] ||= AU3_Function.new("WinWaitActive", 'SSL', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide, timeout) != 0
    end
    
    #Waits for +self+ to be closed. 
    def wait_close(timeout = 0)
      Window.functions[__method__] ||= AU3_Function.new("WinWaitClose", 'SSL', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide, timeout) != 0
    end
    
    #Waits for +self+ to lose the input focus. 
    def wait_not_active(timeout = 0)
      Window.functions[__method__] ||= AU3_Function.new("WinWaitNotActive", 'SSL', 'L')
      Window.functions[__method__].call(@title.wide, @text.wide, timeout) != 0
    end
    
    #Returns the actually focused control in +self+, a AutoItX3::Control object. 
    #Note that if the owning window doesn't have the input focus, you'll get an 
    #unusable Control object back. 
    def focused_control
      Window.functions[__method__] ||= AU3_Function.new("ControlGetFocus", 'SSPI')
      buffer = " " * AutoItX3::BUFFER_SIZE
      buffer.wide!
      Window.functions[__method__].call(@title.wide, @text.wide, buffer, AutoItX3::BUFFER_SIZE - 1)
      AutoItX3::Control.new(@title, @text, buffer.normal.strip)
    end
    
    #Reads the text of the statusbar at position +part+. This method 
    #raises an Au3Error if there's no statusbar, it's not a mscommon 
    #statusbar or if you try to read a position out of range. 
    def statusbar_text(part = 1)
      Window.functions[__method__] ||= AU3_Function.new("StatusbarGetText", 'SSLPI')
      buffer = " " * AutoItX3::BUFFER_SIZE
      buffer.wide!
      Window.functions[__method__].call(@title.wide, @text.wide, part, buffer, AutoItX3::BUFFER_SIZE - 1)
      raise(Au3Error, "Couldn't read statusbar text!") if AutoItX3.last_error == 1
      buffer.normal.strip
    end
    
    private
    
    #Raises an error that says, that +self+ couldn't be found. 
    def raise_unfound
      raise(Au3Error, "Unable to find a window with title '#{@title}' and text '#{@text}'!", caller)
    end
    
  end
  
end