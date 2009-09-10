#Encoding: Windows-1252
#This file is part of au3. 
#Copyright (c) 2009 Marvin Gülker
begin
  require "../ext/au3" 
rescue LoadError
  #Aha, this is the gem, not the build environment
  require "au3"
end
require "test/unit"

class IniTest < Test::Unit::TestCase
  
  TEST_INI =<<EOF
[Section1]
key1=val1
[Section2]
key1=val2
EOF
  
  INI_NAME = "test.ini"
  
  def self.startup
    File.open(INI_NAME, "w"){|f| f.write(TEST_INI)}
  end
  
  def test_read
    assert_equal("val1", AutoItX3.read_ini_entry(INI_NAME, "Section1", "key1", ""))
    assert_equal("val2", AutoItX3.read_ini_entry(INI_NAME, "Section2", "key1", ""))
    assert_equal("XXX", AutoItX3.read_ini_entry(INI_NAME, "Section3", "key1", "XXX"))
  end
  
  def test_write
    AutoItX3.write_ini_entry(INI_NAME, "NewSection", "key", "aValue")
    assert_equal("aValue", AutoItX3.read_ini_entry(INI_NAME, "NewSection", "key", ""))
  end
  
  def test_delete
    AutoItX3.write_ini_entry(INI_NAME, "ASection", "key", "aValue")
    AutoItX3.delete_ini_entry(INI_NAME, "ASection", "key")
    assert_equal("XXX", AutoItX3.read_ini_entry(INI_NAME, "ASection", "key", "XXX"))
  end
  
  def self.shutdown
    File.delete(INI_NAME)
  end
  
end
