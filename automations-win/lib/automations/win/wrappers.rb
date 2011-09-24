# -*- coding: utf-8 -*-
#This file just requires all wrappers.

#This module contains all wrappers for the C-ish Win32 API.
#As a normal user you don't want to use what's inside of this
#module. It's contents are not documented, because it's a thin
#wrapper around the bare C functions/structs/constants whose
#documentation can be seen at 
#http://msdn.microsoft.com/en-us/library/aa383749%28VS.85%29.aspx.
module Automations::Win::Wrappers
end

require_relative "wrappers/constants"
require_relative "wrappers/functions"
