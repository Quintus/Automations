#Encoding: Windows-1252
=begin
This file is part of au3. 
Copyright © 2009 Marvin Gülker

au3 is published under the same terms as Ruby. 
See http://www.ruby-lang.org/en/LICENSE.txt
=end
require "mkmf"
extension_name = "au3"
$LOCAL_LIBS += File.file?("libautoitx3.a") ? "libautoitx3.a" : "AutoItX3.lib"

dir_config(extension_name)
create_makefile(extension_name)