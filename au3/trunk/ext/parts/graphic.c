/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*
*=graphic.c
*This file contains graphical related methods. 
*/

VALUE method_pixel_checksum(int argc, VALUE argv[], VALUE self)
{
  int step = 1;
  unsigned long result;
  
  check_for_arg_error(argc, 4, 5);
  
  if (argc == 5)
    step = FIX2INT(argv[4]);
  
  result = AU3_PixelChecksum(FIX2INT(argv[0]), FIX2INT(argv[1]), FIX2INT(argv[2]), FIX2INT(argv[3]), step);
  return NUM2INT(result);
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_get_pixel_color(VALUE self, VALUE x, VALUE y)
{
  return INT2NUM(AU3_PixelGetColor(FIX2INT(x), FIX2INT(y)));
}
//------------------------------------------------------------------------------------------------------------------------------------------
VALUE method_search_for_pixel(int argc, VALUE argv[], VALUE self)
{
  int shade_var = 0;
  int step = 1;
  int result[2];
  LPPOINT presult = (LPPOINT) result;
  
  //This function doesn't work correctly. 
  rb_raise(rb_eNotImpError, "This function isn't yet implemented.");
  
  check_for_arg_error(argc, 5, 7);
  
  if (argc >= 6)
    shade_var = FIX2INT(argv[5]);
  if (argc >= 7)
    step = FIX2INT(argv[6]);
  
  AU3_PixelSearch(FIX2INT(argv[0]), FIX2INT(argv[1]), FIX2INT(argv[2]), FIX2INT(argv[3]), NUM2INT(argv[4]), shade_var, step, presult);
  
  return rb_ary_new3(2, INT2FIX(result[0]), INT2FIX(result[1]));
}
