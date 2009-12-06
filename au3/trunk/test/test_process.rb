#Encoding: Windows-1252
#This file is part of au3. 
#Copyright (c) 2009 Marvin Gülker
begin
  require_relative "../lib/au3"
rescue LoadError
  #Aha, this is the gem, not the build environment
  require "au3"
end
require "test/unit"

class ProcessTest < Test::Unit::TestCase
  
  DUMMY_PROG =<<EOF
#Encoding: Windows-1252
loop{sleep 1}
EOF
  
  def self.startup
    AutoItX3.opt("WinTitleMatchMode", 2)
  end
  
  def test_exists
    assert_equal($$, AutoItX3.process_exists?($$))
  end
  
  def test_kill
    File.open("dummy.rb", "w"){|f| f.write(DUMMY_PROG)}
    pid = AutoItX3.run("ruby dummy.rb")
    sleep 1
    assert_equal(pid, AutoItX3.process_exists?(pid))
    AutoItX3.kill_process(pid)
    sleep 1
    assert_equal(false, AutoItX3.process_exists?(pid))
    File.delete("dummy.rb")
  end
  
  def test_wait
    pid = AutoItX3.run("mspaint")
    assert(AutoItX3.wait_for_process("mspaint.exe", 5))
    sleep 1
    AutoItX3.kill_process(pid)
    assert(AutoItX3.wait_for_process_close("mspaint.exe", 2))
  end
  
  def test_run_and_wait
    assert_raises(AutoItX3::Au3Error){AutoItX3.run_and_wait("dir gibtsnich")}
  end
  
end
