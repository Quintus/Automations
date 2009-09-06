/*
*This file is part of au3. 
*Copyright © 2009 Marvin Gülker
*
*au3 is published under the same terms as Ruby. 
*See http://www.ruby-lang.org/en/LICENSE.txt
*/

/*
*Converts a char * to a wchar_t * (LPCWSTR). 
*- [in] to_convert: The string to convert. 
*Returnvalue: 
*The converted string. 
*Notes: 
*As a function call parameter you can simply do a conversion like "to_wchar_t("ABC"). 
*This way of using to_wchar_t isn't suitable for a variable initialization. You must use 
* LPCWSTR instead of wchar_t *. 
*LPCWSTR str = to_wchar_t("ABC")
*/
LPCWSTR to_wchar_t(char *to_convert)
{
  int length_of_string = mbstowcs(NULL, to_convert, 0) + 1;
  wchar_t *result = (wchar_t *) malloc(length_of_string * sizeof(wchar_t));
  mbstowcs(result, to_convert, length_of_string);
  return result;
}

/*
*Converts a wchar_t * (LPCWSTR) to a normal C string (char *). 
*- [in]to_convert: The string to convert. 
*Returnvalue: 
*The converted string. 
*/
char * to_char(LPCWSTR to_convert)
{
  int length_of_string = wcstombs(NULL, to_convert, 0) + 1;
  char * result = (char *) malloc(length_of_string * sizeof(char));
  wcstombs(result, to_convert, length_of_string);
  return result;
}
