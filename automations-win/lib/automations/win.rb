# -*- coding: utf-8 -*-
require "pathname"
require "ffi"

#Namespace of the Automations project.
module Automations

  #This library's namespace.
  module Win

    #The library's root path.
    ROOT_PATH = Pathname.new(__FILE__).dirname.expand_path.parent.parent
    #The version of the library.
    VERSION = ROOT_PATH.join("VERSION").read.chomp.freeze

  end

end

require_relative "win/utilities"
require_relative "win/wrappers"
