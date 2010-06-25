#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2009 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 
require "open3"
require_relative("../xdo")
module XDo
  
  #This class represents a window on the screen. Each window is uniquely identified by 
  #an internal ID; before you can create a reference to a window (a XWindow object) you 
  #have to obtain the internal ID of that window and pass it into XWindow.new. 
  #Or you use the class methods of this class, notably XWindow.active_window. 
  #
  #Via the XWindow object you get you can manipulate a window in serveral ways, e.g. 
  #you can move or resize it. Some methods are not available on every window 
  #manager: XWindow.active_window, XWindow.desktop_num, XWindow.desktop_num=, XWindow.desktop, 
  #XWindow.desktop=, XWindow.from_active, #raise, #activate, #desktop, #desktop=. 
  #Some of them may be available, some not. On my machine (an Ubuntu Jaunty) for 
  #example I can use active_window, desktop_num and #activate, but not #raise or #desktop=. 
  #Those methods are tagged with the sentence "Part of the EWMH standard XY". Not all 
  #parts of the EWMH standard are provided by every window manager. 
  #
  #Many methods accept a +name+ parameter; be aware that this name is not the whole 
  #name of a window, but a pattern to match. So, if you pass in "edit", it will even match "gedit". 
  #+xdotool+ handles that parameter with C style regexps. 
  #
  #The +opt+ parameter of many methods is a hash that can have the following keys: 
  #  Key          | Effect if true
  #  =============+====================================
  #  :title       | Window titles are searched. 
  #  -------------+------------------------------------
  #  :name        | Window names are searched. 
  #  -------------+------------------------------------
  #  :class       | Window classes are searched. 
  #  -------------+------------------------------------
  #  :onlyvisible | Only visible windows are searched. 
  #The default values for them depend on the method you want to use. See the method's 
  #argument list to find out if a parameter is set to true or, if it isn't mentioned, to nil. 
  #
  #Be <i>very careful</i> with the methods that are part of the two desktop EWMH standards. 
  #After I set the number of desktops and changed the current desktop, I had to reboot my 
  #system to get the original configuration back. I don't know if I'm not using +xdotool+ correct, 
  #but neither my library nor +xdotool+ itself could rescue my desktop settings. Btw, that's the 
  #reason why it's not in XDo's unit tests (but it should work; at least in one way...). 
  class XWindow
    include Open3
    #The internal ID of the window. 
    attr_reader :id
    
    class << self
      include Open3
      #Checks if a window whose name matches +name+ exists. 
      #Think about passing :onlyvisible in the +opt+ hash. 
      def exists?(name, opts = {title: true, name: true, :class => true})
        begin
          !search(name, opts).empty?
        rescue
          false
        end
      end
      
      #Returns true if the given window ID exists, false otherwise. 
      def id_exists?(id)
        err = ""
        popen3("#{XDo::XWININFO} -id #{id}"){|stdin, stdout, stderr| err << stderr.read}
        return false unless err.empty?
        return true
      end
      
      #Waits for a window name to exist and returns the ID of that window. 
      #Returns immediately if the window does already exist. 
      def wait_for_window(name, opts = {title: true, name: true, :class => true, :onlyvisible => true})
        loop{break if exists?(name, opts);sleep(0.5)}
        sleep 1 #To ensure it's really there
        search(name, opts).first
      end
      
      #Waits for a window to close. If the window does not exists when calling +wait_for_close+, 
      #the method returns immediately. 
      def wait_for_close(name, opts = {title: true, name: true, :class => true, :onlyvisible => true})
        loop{break if !exists?(name, opts);sleep(0.5)}
        nil
      end
      
      #Search for a window name to get the internal ID of a window. 
      #Return value is an array containing all found IDs or an 
      #empty array if none is found. 
      def search(name, opts = {title: true, name: true, :class => true})
        cmd = "#{XDo::XDOTOOL} search "
        opts.each_pair{|key, value| cmd << "--#{key} " if value}
        cmd << '"' << name << '"'
        #Error wird nicht behandelt, weil im Fehlerfall einfach nur ein leeres Array zurückkommen soll
        out = `#{cmd}`
        out.lines.to_a.collect{|l| l.strip.to_i}
      end
      
      #Returns the internal ID of the currently focused window. 
      #If the +notice_childs+ parameter is true, also childwindows 
      #are noticed. This method may find an invisible window, see 
      #active_window for a more reliable method. 
      def focused_window(notice_childs = false)
        err = ""
        out = ""
        popen3("#{XDo::XDOTOOL} getwindowfocus #{notice_childs ? "-f" : ""}"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        return out.to_i
      end
      
      #Returns the internal ID of the currently focused window. 
      #This method is more reliable than focused_window. 
      #Part of the EWMH standard ACTIVE_WINDOW. 
      def active_window
        err = ""
        out = ""
        popen3("#{XDo::XDOTOOL} getactivewindow"){|stdin, stdout, stderr| out = stdout.read; err = stderr.read}
        raise(XDo::XError, err) unless err.empty?
        return Integer(out)
      end
      
      #Set the number of working desktops. 
      #Part of the EWMH standard WM_DESKTOP. 
      def desktop_num=(num)
        err = ""
        popen3("#{XDo::XDOTOOL} set_num_desktops #{num}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::Error, err) unless err.empty?
        num
      end
      
      #Get the number of working desktops. 
      #Part of the EWMH standard WM_DESKTOP. 
      def desktop_num
        err = ""
        out = ""
        popen3("#{XDo::XDOTOOL} get_num_desktops"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        Integer(out)
      end
      
      #Change the view to desktop +num+. 
      #Part of the EWMH standard CURRENT_DESKTOP. 
      def desktop=(num)
        err = ""
        popen3("#{XDo::XDOTOOL} set_desktop #{num}"){|stdin, stdout, stderr| err << stderr.read}
        raise(XDo::XError, err) unless err.empty?
        num
      end
      
      #Output the number of the active desktop. 
      #Part of the EWMH standard CURRENT_DESKTOP. 
      def desktop
        err = ""
        out = ""
        popen3("#{XDo::XDOTOOL} get_desktop"){|stdin, stdout, stderr| out = stdout.read; err = stderr.read}
        raise(XDo::XError, err) unless err.empty?
        Integer(out)
      end
      
      #Creates a XWindow by calling search with the given parameters. 
      #The window is created from the first ID found. 
      def from_name(name, opts = {title: true, name: true, :class => true})
        ids = search(name, opts)
        raise(XDo::XError, "The window '#{name}' wasn't found!") if ids.empty?
        new(ids.first)
      end
      
      #Creates a XWindow by calling focused_window with the given parameter. 
      def from_focused(notice_childs = false)
        new(focused_window(notice_childs))
      end
      
      #Creates a XWindow by calling active_window. 
      def from_active
        new(active_window)
      end
      
      #Set this to the name of your desktop window. 
      def desktop_name=(name)
        @desktop_name = name
      end
      
      #Name of the desktop window. Default is "x-nautilus-desktop". 
      def desktop_name
        @desktop_name ||= "x-nautilus-desktop"
      end
      
      #Activate the desktop
      def focus_desktop
        desktop = from_name(desktop_name)
        desktop.focus
        desktop.activate
      end
      alias activate_desktop focus_desktop
      
      #Minimize all windows (or restore, if already) by sending [CTRL]+[ALT]+[D]. 
      #Available after requireing  "xdo/keyboard". 
      def toggle_minimize_all
        raise(NotImplementedError, "You have to require 'xdo/keyboard' before you can use #{__method__}!") unless defined? XDo::Keyboard
        XDo::Keyboard.ctrl_alt_d
      end
      
      #Minimizes the active window. There's no way to restore a specific minimized window. 
      #Available after requireing "xdo/keyboard". 
      def minimize
        raise(NotImplementedError, "You have to require 'xdo/keyboard' before you can use #{__method__}!") unless defined? XDo::Keyboard
        XDo::Keyboard.key("Alt+F9")
      end
      
      #Maximize or normalize the active window if already maximized. 
      #Available after requireing "xdo/keyboard". 
      def toggle_maximize
        raise(NotImplementedError, "You have to require 'xdo/keyboard' before you can use #{__method__}!") unless defined? XDo::Keyboard
        XDo::Keyboard.key("Alt+F10")
      end
      
    end
    
    #Creates a new XWindow object from an internal ID. See the XWindow class methods. 
    def initialize(id)
      @id = id.to_i
    end
    
    #Human-readable output of form
    #  <XDo::XWindow: "title" (window_id)>
    def inspect
      %Q|<XDo::XWindow: "#{title}" (#{id})>|
    end
    
    #Set the size of a window. This has no effect on maximized winwows. 
    def resize(width, height, use_hints = false)
      err = ""
      cmd = "#{XDo::XDOTOOL} windowsize #{use_hints ? "--usehints " : ""}#{@id} #{width} #{height}"
      popen3("#{cmd}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #Moves a window. +xdotool+ is not really exact with the coordinates, 
    #the window will be within a range of +-10 pixels. 
    def move(x, y)
      err = ""
      popen3("#{XDo::XDOTOOL} windowmove #{@id} #{x} #{y}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #Set the input focus to the window (but don't bring it to the front). 
    def focus
      err = ""
      popen3("#{XDo::XDOTOOL} windowfocus #{@id}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #The window loses the input focus by setting it to the desktop. 
    def unfocus
      XDo::XWindow.focus_desktop
    end
    
    #Map a window to the screen (make it visible). 
    def map
      err = ""
      popen3("#{XDo::XDOTOOL} windowmap #{@id}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #Unmap a window from the screen (make it invisible). 
    def unmap
      err = ""
      popen3("#{XDo::XDOTOOL} windowunmap #{@id}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #Bring a window to the front (but don't give it the input focus). 
    #Not implemented in all window managers. 
    def raise
      err = ""
      popen3("#{XDo::XDOTOOL} windowraise #{@id}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #Activate a window. That is, bring it to top and give it the input focus. 
    #Part of the EWMH standard ACTIVE_WINDOW. 
    def activate
      err = ""
      popen3("#{XDo::XDOTOOL} windowactivate #{@id}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #Move a window to a desktop. 
    #Part of the EWMH standard CURRENT_DESKTOP. 
    def desktop=(num)
      err = ""
      popen3("#{XDo::XDOTOOL} set_desktop_for_window #{@id} #{num}"){|stdin, stdout, stderr| err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
    end
    
    #Get the desktop the window is on. 
    #Part of the EWMH standard CURRENT_DESKTOP. 
    def desktop
      err = ""
      out = ""
      popen3("#{XDo::XDOTOOL} get_desktop_for_window #{@id}"){|stdin, stdout, stderr| out = stdout.read; err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
      Integer(out)
    end
    
    #The title of the window or nil if it doesn't have a title. 
    def title
      err = ""
      out = ""
      popen3("#{XDo::XWININFO} -id #{@id}"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
      title = out.strip.lines.to_a[0].match(/"(.*)"/)[1] rescue Kernel.raise(XDo::XError, "No window with ID #{@id} found!")
      return title #Kann auch nil sein, dann ist das Fenster namenlos. 
    end
    
    #The absolute position of the window on the screen. 
    def abs_position
      out = ""
      err = ""
      popen3("#{XDo::XWININFO} -id #{@id}"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
      out = out.strip.lines.to_a
      x = out[2].match(/:\s+(\d+)/)[1]
      y = out[3].match(/:\s+(\d+)/)[1]
      [x.to_i, y.to_i]
    end
    alias position abs_position
    
    #The position of the window relative to it's parent window. 
    def rel_position
      out = ""
      err = ""
      popen3("#{XDo::XWININFO} -id #{@id}"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
      out = out.strip.lines.to_a
      x = out[4].match(/:\s+(\d+)/)[1]
      y = out[5].match(/:\s+(\d+)/)[1]
      [x.to_i, y.to_i]
    end
    
    #The size of the window. 
    def size
      out = ""
      err = ""
      popen3("#{XDo::XWININFO} -id #{@id}"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
      out = out.strip.lines.to_a
      Kernel.raise(XDo::XError, err) unless err.empty?
      width = out[6].match(/:\s+(\d+)/)[1]
      height = out[7].match(/:\s+(\d+)/)[1]
      [width.to_i, height.to_i]
    end
    
    #true if the window is mapped to the screen. 
    def visible?
      err = ""
      out = ""
      popen3("#{XDo::XWININFO} -id #{@id}"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
      out = out.strip.lines.to_a
      Kernel.raise(XDo::XError, err) unless err.empty?
      return out[17].match(/:\s+(\w+)/)[1] == "IsViewable" ? true : false
    end
    
    #Returns true if the window exists. 
    def exists?
      XDo::XWindow.exists?(@id)
    end
    
    #Closes a window by activating it and then sending [ALT] + [F4]. 
    #A program could ask to save data. 
    #Use #kill! to kill the process running the window. 
    #Available after requireing "xdo/keyboard"
    def close
      Kernel.raise(NotImplementedError, "You have to require 'xdo/keyboard' before you can use #{__method__}!") unless defined? XDo::Keyboard
      activate
      sleep 0.5
      XDo::Keyboard.char("Alt+F4")
      sleep 0.5
      nil
    end
    
    #More aggressive variant of #close. Think of +close!+ as 
    #the middle between #close and #kill!. It first tries 
    #to close the window by calling #close and if that 
    #does not succeed (within +timeout+ seconds), it will call #kill!. 
    #Available after requireing "xdo/keyboard". 
    def close!(timeout = 2)
      Kernel.raise(NotImplementedError, "You have to require 'xdo/keyboard' before you can use #{__method__}!") unless defined? XDo::Keyboard
      #Try to close normally
      close
      #Check if it's deleted
      if exists?
        #If not, wait some seconds and then check again
        sleep timeout
        if exists?
          #If it's not deleted after some time, force it to close. 
          kill!
        else
          return
        end
      else
        return
      end
    end
    
    #Kills the process that runs a window. The window will be 
    #terminated immediatly, if that isn't what you want, have 
    #a look at #close. 
    def kill!
      out = ""
      err = ""
      popen3("#{XDo::XKILL} -id #{@id}"){|stdin, stdout, stderr| out << stdout.read; err << stderr.read}
      Kernel.raise(XDo::XError, err) unless err.empty?
      nil
    end
    
    def to_i
      @id
    end
    
    def to_s
      title
    end
    
    def zero?
      @id.zero?
    end
    
    def nonzero?
      @id.nonzero?
    end
    
  end
  
end