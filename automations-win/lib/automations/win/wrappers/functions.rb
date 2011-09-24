# -*- coding: utf-8 -*-

#This module wraps all the C functions accessed from the win32 API.
#
#==Calling lowlevel WinAPI functions
#You can access them directly, e.g. by calling:
#  Functions.message_box(...)
#This has the mayor disadvantage that you have to cope with error codes
#indicated by your function. Windows function usually return 0 when they
#find themselves in an error condition and leave it to you to call the
#WinAPI function <tt>GetLastError()</tt> which gives you the actual error
#code you could then translate via the <tt>FormatMessage()</tt> function.
#To specifically address this issue, the ::scall method exists. It just calls
#the function whose symbol you pass in, but then checks the return value, and,
#even better, raises a SystemCallError exception with the description of the
#error code. So, unless your function doesn't set an error code you should
#use ::scall to invoke the WinAPI functions wrapped by this module ("scall"
#is actually an acronym for "secure call", but as you should use it for the
#most function invocations, you could think of it as "system call", but don't
#confuse this with UNIX system calls).
#
#==Strings
#The WinAPI knows about two kinds of strings, ASCII and Unicode ones. They
#directly map to the two Ruby encodings ASCII-8BIT and UTF16LE ("LE" means
#"little endian", it indicates reversed byte order), but you will only
#find yourself to cope with the latter one as all functions wrapped by
#this module that support both ASCII and Unicode versions only choose
#the Unicode version. For instance, the <tt>MessageBox()</tt> function,
#which you should not use directly, comes in the two flavours
#<tt>MessageBoxA()</tt> (the ASCII version) and <tt>MessageBoxW()</tt> (the
#Unicode version). If you look into this module's method, you'll find
#there's just one #message_box method and this method wraps solely
#the <tt>MessageBoxW()</tt> function, which therefore accepts
#strings encoded in UTF-16LE. The same goes for any string buffers used by
#WinAPI functions, they accept and return UTF-16LE strings.
#
#Please note that the term "Unicode" doesn't always imply the "UTF-16LE"
#encoding (that was an invention by Microsoft). The word "Unicode" just
#refers to the standard containing all the world's glyphs, and that
#standard is made accessible through the UTF-* encodings which all can
#access the whole glyph table, but do it in a slightly different way.
module Automations::Win::Wrappers::Functions
  extend Automations::Win::Utilities
  extend FFI::Library

  ffi_lib "user32", "kernel32"
  ffi_convention :stdcall

  #"Securely" calls a Win API function. "Securly" means that, if the
  #function returns an integer value, the value is checked whether it's
  #zero. If so, Window's GetLastError() function is called and a
  #SystemCallError exception is raised with the description of the error.
  #==Parameters
  #[sym] The name of the method to call. One of those defiend via FFI's +attach_function+.
  #[*args] This is just passed through to the method you want to call.
  #[&block] This is just passed through to the method you want to call.
  #==Raises
  #[SystemCallError] As described above.
  #==Return value
  #The return value of the method you specified.
  #==Example
  #  ptr = FFI::MemoryPointer.new(512)
  #  Misc.msgbox("Foo", "Foo", ptr, :ok) #=> SystemCallError "invalid handle"
  def self.scall(sym, *args, &block)
    raise(NoMethoderror, "Undefined method `#{sym}' for #{inspect}!") unless respond_to?(sym)

    r = send(sym, *args, &block)
    
    if r.respond_to?(:to_int) and r.to_int.zero?
      #That's really cool--Ruby's SystemCallError class already knows how to
      #transform system error codes into messages. Yeah!
      raise(SystemCallError.new("Function #{sym} failed", get_last_error()))
    end

    r
  end
  
  attach_function :get_last_error, :GetLastError, [], :int
  attach_function :format_message, :FormatMessageW, [:int, :buffer_in, :int, :int, :buffer_out, :int, :pointer], :int #The last pointer is actually varargs...
  attach_function :message_box, :MessageBoxW, [:pointer, :buffer_in, :buffer_in, :uint], :int

end
