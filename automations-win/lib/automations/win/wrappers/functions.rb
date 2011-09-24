# -*- coding: utf-8 -*-

#This module wraps all the C functions accessed from the win32 API.
module Automations::Win::Wrappers::Functions
  extend FFI::Library

  ffi_lib "user32"
  ffi_convention :stdcall

  attach_function :message_box, :MessageBoxW, [:pointer, :buffer_in, :buffer_in, :uint], :int

end
