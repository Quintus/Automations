#!/usr/bin/env ruby
#Encoding: UTF-8
require "test/unit"
require "xdo/drive.rb"

class DriveTest < Test::Unit::TestCase
  
  def test_eject
    begin
      XDo::Drive.eject
      sleep 2
      begin
        XDo::Drive.close
      rescue XDo::XError #A laptop drive will raise an XDo::XError since it has to be closed manually
        notify "Couldn't close your CD-ROM drive. Are you using a laptop?"
      end
      assert(true)
    rescue
      assert(false, $!.message)
    end
  end
  
end
