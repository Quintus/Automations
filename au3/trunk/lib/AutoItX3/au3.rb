#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt
#
#===au3.rb
#This is au3's main file. 
require "win32/api"
#(See the end of this file for more require statements)

#Added some methods to the build-in String class. 
class String
  
  #The AutoItX3 API requires wchar_t * (or LPCWSTR) typed strings instead of the usual char *. 
  #After some web research I found out that this type is a UTF-16 encoded string, 
  #that has to be terminated with a double NUL character; I tried to encode the 
  #string UTF-16BE, then UTF-16LE and added the extra NUL to it, and found out 
  #it worked. That's what this method does. 
  def wide
    (self + "\0").encode("UTF-16LE")
  end
  alias to_wchar_t wide
  
  #Self-modifying version of #wide. 
  def wide!
    self << "\0"
    encode!("UTF-16LE")
  end
  
  #The AutoItX3 API returns wchar_t * (or LPCSWSTR) typed strings instead of the usual char *. 
  #This method should only be used for strings that have been created by #wide or by the au3 API 
  #(which uses #wide internally). Keep in mind that this method removes unconvertable characters. 
  #
  #Returns an +encoding+ encoded string that has been a wchar_t * (LPCWSTR) type. 
  def normal(encoding = "UTF-8")
    encode(encoding, :invalid => :replace, :undef => :replace, :replace => "").gsub("\0", "").gsub("\r\n", "\n")
  end
  alias to_char normal
  
  #Self-modifying version of #normal. 
  def normal!(encoding = "UTF-8")
    encode!(encoding, :invalid => :replace, :undef => :replace, :replace => "")
    gsub!("\0", "")
    gsub!("\r\n", "\n")
  end
  
end

#This module encapsulates all methods to interact with 
#AutoItX3. Every method is documented, so you should't have 
#problems with using them. However, a few notes: 
#==Mouse Functions
#Many mouse functions take an argument called +button+. This can be one 
#of the following strings: 
#  String              | Normal result   | Swapped buttons
#  ====================+=================+================
#  "" (empty string)   | Left            | Left
#  --------------------+-----------------+----------------
#  Left                | Left            | Left
#  --------------------+-----------------+----------------
#  Right               | Right           | Right
#  --------------------+-----------------+----------------
#  Middle              | Middle          | Middle
#  --------------------+-----------------+----------------
#  Primary             | Left            | Right
#  --------------------+-----------------+----------------
#  Secondary           | Right           | Left
#  --------------------+-----------------+----------------
#  Main                | Left            | Right
#  --------------------+-----------------+----------------
#  Menu                | Right           | Left
#==Process Functions
#The +pid+ parameter of many process functions 
#needn't to be a process identification number, you can 
#also pass in the name of the process. Please note, that 
#in that case the first process with +pid+ in its name is 
#assumed to be the correct one. 
module AutoItX3
  
  #The smallest value AutoIt can handle. Used for *some* parameter defaults. 
  INTDEFAULT = -2147483647
  
  #The version of this au3 library. 
  VERSION = "0.1.2-dev (9.5.10)"
  
  #This is the buffer size used for AutoItX3's text "returning" functions. 
  #It will be subtracted by 1 due to the trailing 0 of wchar_t * type strings. 
  BUFFER_SIZE = 100_000
  
  #This is used to store the Win32::API objects. 
  @functions = {}
  
  #This hash is used for the #set_option method. 
  @options = {
    "CaretCoordMode" => 2, 
    "ColorMode" => 0, 
    "MouseClickDelay" => 10, 
    "MouseClickDownDelay" => 10, 
    "MouseClickDragDelay" => 250, 
    "MouseCoordMode" => 1, 
    "PixelCoordMode" => 1, 
    "SendAttachMode" => 0, 
    "SendCapslockMode" => 1, 
    "SendKeyDelay" => 5, 
    "SendKeyDownDelay" => 1, 
    "WinDetectHiddenText" => 0, 
    "WinSearchChildren" => 0, 
    "WinTextMatchMode" => 1, 
    "WinTitleMatchMode" => 1, 
    "WinWaitDelay" => 250
  }
  
  #All yet assigned functions. 
  def self.functions
    @functions
  end
  
  #Reset all functions to the given hash. 
  def self.functions=(val)
    @functions = val
  end
  
  #This class is used for errors in this library. 
  class Au3Error < StandardError
  end
  
  #This subclass of Win32::API is only used internally to make it a bit easier 
  #to create bindings the functions of AutoItX3. 
  class AU3_Function < Win32::API
    
    #Creates a new AU3_Function object. Takes the +name+, the +arguments+ and the +returnvalue+ of 
    #the function. +name+ will be prefixed by "AU3_" and the DLL is set to "AutoItX3.dll". 
    #If you ommit the returnvalue, it's assumed to be of void type ('V'). 
    def initialize(name, arguments, returnvalue = 'V')
      super("AU3_#{name}", arguments, returnvalue, "AutoItX3.dll")
    end
    
  end
  
  class << self
    
    #This hash is used for the #set_option method. 
    #Use the #set_option method to configure it. 
    attr_reader :options
    
    #Returns the error code of the last called AutoItX3 function, which is 0 if 
    #everything worked fine. 
    def last_error
      @functions[__method__] ||= AU3_Function.new("error", '', 'L')
      @functions[__method__].call
    end
    
    #call-seq: 
    #  set_option( option , value ) ==> anInteger
    #  set_option( option , value) {...} ==> anObject
    #  opt( option , value ) ==> anInteger
    #  opt( option , value ) {...} ==> anObject
    #
    #Sets an option that changes the behaviour of AutoIt. If you choose the block form, the 
    #option will be resetted after the block finished. 
    #The block form returns the last expression, the normal form the previously set option. 
    #
    #The following options are possible (copied from the AutoItX3 help file): 
    #  Option              | Description
    #  ====================+============================================================
    #  CaretCoordMode      | Sets the way coords are used in the caret functions, 
    #                      | either absolute coords or coords relative to the current 
    #                      | active window:
    #                      | 0 = relative coords to the active window
    #                      | 1 = absolute screen coordinates (default)
    #                      | 2 = relative coords to the client area of the active window
    #  --------------------+------------------------------------------------------------
    #  ColorMode           | Sets the way colors are defined, either RGB or BGR. RGB is 
    #                      | the default but in previous versions of AutoIt (pre 3.0.102) 
    #                      | BGR was the default:
    #                      | 0 = Colors are defined as RGB (0xRRGGBB) (default)
    #                      | 1 = Colors are defined as BGR (0xBBGGRR) (the mode used in 
    #                      |     older versions of AutoIt)
    #  --------------------+------------------------------------------------------------
    #  MouseClickDelay     | Alters the length of the brief pause in between mouse 
    #                      | clicks. 
    #                      | Time in milliseconds to pause (default=10). 
    #  --------------------+------------------------------------------------------------
    #  MouseClickDownDelay | Alters the length a click is held down before release. 
    #                      | Time in milliseconds to pause (default=10). 
    #  --------------------+------------------------------------------------------------
    #  MouseClickDragDelay | Alters the length of the brief pause at the start and 
    #                      | end of a mouse drag operation. 
    #                      | Time in milliseconds to pause (default=250). 
    #  --------------------+------------------------------------------------------------
    #  MouseCoordMode      | Sets the way coords are used in the mouse functions, 
    #                      | either absolute coords or coords relative to the current 
    #                      | active window: 
    #                      | 0 = relative coords to the active window
    #                      | 1 = absolute screen coordinates (default)
    #                      | 2 = relative coords to the client area of the active window
    #  --------------------+------------------------------------------------------------
    #  PixelCoordMode      | Sets the way coords are used in the pixel functions, 
    #                      | either absolute coords or coords relative to the current 
    #                      | active window:
    #                      | 0 = relative coords to the active window
    #                      | 1 = absolute screen coordinates (default)
    #                      | 2 = relative coords to the client area of the active window
    #  --------------------+------------------------------------------------------------
    #  SendAttachMode      | Specifies if AutoIt attaches input threads when using then 
    #                      | Send() function. When not attaching (default mode=0) 
    #                      | detecting the state of capslock/scrolllock and numlock 
    #                      | can be unreliable under NT4. However, when you specify 
    #                      | attach mode=1 the Send("{... down/up}") syntax will not 
    #                      | work and there may be problems with sending keys to "hung" 
    #                      | windows. ControlSend() ALWAYS attaches and is not affected 
    #                      | by this mode. 
    #                      | 0 = don't attach (default)
    #                      | 1 = attach
    #  --------------------+------------------------------------------------------------
    #  SendCapslockMode    | Specifies if AutoIt should store the state of capslock 
    #                      | before a Send function and restore it afterwards. 
    #                      | 0 = don't store/restore
    #                      | 1 = store and restore (default)
    #  --------------------+------------------------------------------------------------
    #  SendKeyDelay        | Alters the the length of the brief pause in between 
    #                      | sent keystrokes. 
    #                      | Time in milliseconds to pause (default=5). Sometimes a 
    #                      | value of 0 does not work; use 1 instead.
    #  --------------------+------------------------------------------------------------
    #  SendKeyDownDelay    | Alters the length of time a key is held down before 
    #                      | released during a keystroke. For applications that 
    #                      | take a while to register keypresses (and many games) 
    #                      | you may need to raise this value from the default. 
    #                      | Time in milliseconds to pause (default=1).
    #  --------------------+------------------------------------------------------------
    #  WinDetectHiddenText | Specifies if hidden window text can be "seen" by the 
    #                      | window matching functions. 
    #                      | 0 = Do not detect hidden text (default)
    #                      | 1 = Detect hidden text
    #  --------------------+------------------------------------------------------------
    #  WinSearchChildren   | Allows the window search routines to search child windows 
    #                      | as well as top-level windows. 
    #                      | 0 = Only search top-level windows (default)
    #                      | 1 = Search top-level and child windows
    #  --------------------+------------------------------------------------------------
    #  WinTextMatchMode    | Alters the method that is used to match window text 
    #                      | during search operations. 
    #                      | 1 = Complete / Slow mode (default)
    #                      | 2 = Quick mode
    #                      | In quick mode AutoIt can usually only "see" dialog text, 
    #                      | button text and the captions of some controls. In the 
    #                      | default mode much more text can be seen (for instance the 
    #                      | contents of the Notepad window). 
    #                      | If you are having performance problems when performing 
    #                      | many window searches then changing to the "quick" mode may 
    #                      | help. 
    #  --------------------+------------------------------------------------------------
    #  WinTitleMatchMode   | Alters the method that is used to match window titles 
    #                      | during search operations. 
    #                      | 1 = Match the title from the start (default)
    #                      | 2 = Match any substring in the title
    #                      | 3 = Exact title match
    #                      | 4 = Advanced mode, see the AutoItX3 help. 
    #  --------------------+------------------------------------------------------------
    #  WinWaitDelay        | Alters how long a script should briefly pause after a 
    #                      | successful window-related operation. 
    #                      | Time in milliseconds to pause (default=250). 
    def set_option(option, value)
      raise(ArgumentError, "Unknown option '#{option}'!") unless @options.include? option
      @functions[__method__] ||= AU3_Function.new("AutoItSetOption", 'PL', 'L')
      if block_given?
        previous = @options[option]
        @functions[__method__].call(option.to_wchar_t, value)
        ret = yield
        @functions[__method__].call(option.to_wchar_t, previous)
      else
        ret = @functions[__method__].call(option.to_wchar_t, value)
        @options[option] = ret
      end
      ret
    end
    alias opt set_option
    
  end
  
end #AutoItX3

require_relative("./misc.rb")
require_relative("./filedir.rb")
require_relative("./graphic.rb")
require_relative("./keyboard.rb")
require_relative("./mouse.rb")
require_relative("./process.rb")
require_relative("./window.rb")
require_relative("./control.rb")