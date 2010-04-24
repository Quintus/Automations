#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module AutoItX3
  
  class << self
    
    #Computes a checksum of the pixels in the specified region. 
    #===Parameters
    #[+x1+] Upper-left X-Coordinate of the region. 
    #[+y1+] Upper-left Y-Coordinate of the region. 
    #[+x2+] Lower-right X-Coordinate of the region. 
    #[+y2+] Lower-right Y-Coordinate of the region. 
    #[+step+] (1) Indicatates how many pixels are used for the computation. Every <tt>step</tt>-th pixel will be checked. 
    #===Return value
    #The computed checksum. 
    #===Example
    #  #Compute the checksum of [0, 0, 100, 100]
    #  p AutoItX3.pixel_checksum(0, 0, 100, 100) #=> 2252979179
    #  #Then move a window into this region. 
    #  p AutoItX3.pixel_checksum(0, 0, 100, 100) #=> 4287194203
    #===Remarks
    #If the checksum changes, that only indidcates that *something* has changed, not *what*. 
    #Note that this method may be very time-consuming, so think about increasing the 
    #+step+ parameter (but bear in mind that that will generate more inaccurate checksums). 
    def pixel_checksum(x1, y1, x2, y2, step = 1)
      @functions[__method__] ||= AU3_Function.new("PixelChecksum", 'LLLLL', 'L')
      @functions[__method__].call(x1, y1, x2, y2, step)
    end
    
    #Retrieves the color value of the pixel at the specified position. 
    #===Parameters
    #[+x+] The pixel's X coordinate. 
    #[+y+] The pixel's Y coordinate. 
    #[+hex+] Changes the return value, see below. 
    #===Return value
    #The decimal color value of the specified pixel. If you set +hex+ to true, 
    #you get a string in form <tt>#RRGGBB</tt> that describes the color in 
    #hexadecimal format. 
    #===Example
    #  p AutoItX3.get_pixel_color(15, 15) #=> 1057590
    #  p AutoItX3.get_pixel_color(15, 15, true) #=> "#102336"
    def get_pixel_color(x, y, hex = false)
      @functions[__method__] ||= AU3_Function.new("PixelGetColor", 'LL', 'L')
      res = @functions[__method__].call(x, y)
      return "#" + res.to_s(16).upcase if hex
      res
    end
    
  end
  
end