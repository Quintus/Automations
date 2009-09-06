/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*/

/*
*Raises a Ruby ArgumentError. 
*Parameters: 
* [in] got: The number of real got parameters. 
* [in] min: The minumum number of arguments. 
* [in] max: The maximum number of arguments. 
*/
void check_for_arg_error(int got, int min, int max)
{
  char err[80];
  if (got >= min && got <= max)
    return; //No error
  
  if ((min + 1) == max)
    sprintf(err, "Wrong number of arguments, got %i, expected %i! or %i", got, min, max); //special
  else if (got < min)
    sprintf(err, "To few arguments specified (%i), expected at least %i and at most %i!", got, min, max);
  else if (got > max)
    sprintf(err, "To many arguments specified (%i), expected at least %i and at most %i!", got, min, max);
  else
    sprintf(err, "Wrong number of arguments, got %i, expected at least %i and at most %i!", got, min, max);
  rb_raise(rb_eArgError, err);
}

/*
*Converts a Ruby (VALUE) string to an wchar_t string. 
*Parameters: 
* [in] rstr: The Ruby string to convert. 
*Returnvalue: 
*The converted LPCWSTR. 
*/
LPCWSTR rstr_to_wstr(VALUE rstr)
{
  return to_wchar_t(StringValuePtr(rstr));
}

/*
*Converts a unicode string (LPCWSTR, wchar_t[]) to a Ruby string. 
*Parameters: 
* [in] wstr: The string to convert. 
*/
VALUE wstr_to_rstr(LPCWSTR wstr)
{
  return rb_str_new2(to_char(wstr));
}
