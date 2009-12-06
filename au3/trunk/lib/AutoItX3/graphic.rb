#Encoding: UTF-8
#This file is part of au3. 
#Copyright © 2009 Marvin Gülker
#
#au3 is published under the same terms as Ruby. 
#See http://www.ruby-lang.org/en/LICENSE.txt

module AutoItX3
  
  class << self
    
    #Computes a checksum of the pixels in the specified region. If the checksum 
    #changes, that only indidcates that *something* has changed, not *what*. 
    #Note that this method may be very time-consuming, so think about increasing the 
    #+step+ parameter (but bear in mind that that will generate more inaccurate checksums). 
    def pixel_checksum(x1, y1, x2, y2, step = 1)
      @functions[__method__] ||= AU3_Function.new("PixelChecksum", 'LLLLL', 'L')
      @functions[__method__].call(x1, y1, x2, y2, step)
    end
    
    #Retrieves the *decimal* color value of a pixel. If you want the hexadecimal, 
    #pass in true as a third parameter. 
    def get_pixel_color(x, y, hex = false)
      @functions[__method__] ||= AU3_Function.new("PixelGetColor", 'LL', 'L')
      res = @functions[__method__].call(x, y)
      return "#" + res.to_s(16).upcase if hex
      res
    end
    
  end
  
end