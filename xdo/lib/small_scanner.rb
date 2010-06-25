#!/usr/bin/env ruby
#Encoding: UTF-8
#This file is part of Xdo. 
#Copyright © 2010 Marvin Gülker
#  Initia in potestate nostra sunt, de eventu fortuna iudicat. 

#This class is similar to the StringScanner class in the stdlib, 
#but since that one is incapable of handling strings per-character 
#instead of per-byte, I needed an alternative. The methods defined 
#in this class are the same as in StringScanner, except that all 
#of them operate on characters rather than bytes. The returned strings 
#will always be encoded as UTF-8. 
#
#If you're looking for examples, have a look at the documentation of StringScanner, 
#which should work out nearly the same. 
#
#This class is supposed to be a *small* scanner, so it doesn't define all the 
#methods StringScanner has. 
class SmallScanner
  
  #The string passed to SmallScanner.new, encoded as UTF-8. 
  attr_reader :string
  #Match data of the last match. 
  attr_reader :match_data
  
  def initialize(str)
    str = str.encode("UTF-8")
    @string = str
    @unscanned = str.dup
    @consumed = ""
    @match_data = nil
  end
  
  def pos
    @consumed.size
  end
  
  def pos=(val)
    @consumed = @string[0..(val - 1)]
    @unscanned = @string[val..-1]
  end
  
  def getch
    @match_data = nil
    @consumed << @unscanned.slice!(0)
  end
  
  def scan(regexp)
    regexp = Regexp.new("^#{regexp.source}")
    if @unscanned =~ regexp
      @match_data = $~
      str = @unscanned.slice!(0..($&.size - 1))
      @consumed << str
      str
    else
      @match_data = nil
      nil
    end
  end
  
  def scan_until(regexp)
    unscanned = @unscanned.dup
    str = ""
    str << unscanned.slice!(0) until str =~ regexp or unscanned.empty?
    if str =~ regexp
      @match_data = $~
      ret = @unscanned.slice!(0..(str.size - 1))
      @consumed << ret
      ret
    else
      @match_data = nil
      nil
    end
  end
  
  def skip(regexp)
    scan(regexp)
    @match_data.nil? ? nil : @match_data[0].size
  end
  
  def skip_until(regexp)
    scan_until(regexp)
    @match_data.nil? ? nil : @match_data[0].size
  end
  
  def inspect
    "<SmallScanner #{pos}/#{@string.size}>"
  end
  
  def terminate
    @consumed = @string.dup
    @unscanned = ""
  end
  
  def reset
    @consumed = ""
    @unscanned = @string.dup
  end
  
  def rest
    @unscanned
  end
  
  def eos?
    @unscanned.empty?
  end
  
  def pre_match
    @match_data.pre_match
  end
  
  def post_match
    rest
  end
  
  def matched
    @match_data[0]
  end
  
  def concat(str)
    @string << str
    @unscanned << str
  end
  
  def <<(str)
    concat(str)
    self
  end
  
end