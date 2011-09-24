# -*- coding: utf-8 -*-

#This mixin module contains utility methods useful in a number of
#different places.
module Automations::Win::Utilities
  
  #Transforms a string into a Win32-API-usable version by appending
  #a NUL byte and encoding it as UTF-16LE.
  #==Parameter
  #[str] The string to transform.
  #==Return value
  #The transformed string.
  #==Example
  #  wide_str("Bär") #=> UTF-16 Bär with terminating double NUL
  def wide_str(str)
    "#{str}\0".encode("UTF-16LE")
  end

  #Undoes the effect of ::wide_str, i.e. encodes a string to
  #UTF-8 and then strips off trailing NUL bytes.
  #==Parameter
  #[str] The string to transform.
  #==Return value
  #A UTF-8-encoded version of +str+ without any terminating NULs.
  #==Example
  #  s = "Bär\0".encode("UTF-16LE")
  #  p unwide_str(s) #=> "Bär"
  def unwide_str(str)
    str.encode("UTF-8").sub(/\0*$/, "")
  end

end
