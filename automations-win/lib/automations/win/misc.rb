# -*- coding: utf-8 -*-

require_relative "../win"

#This module contains all the methods that didn't fit into other
#scopes.
module Automations::Win::Misc
  extend Automations::Win::Utilities
  
  C = Automations::Win::Wrappers::Constants
  F = Automations::Win::Wrappers::Functions

  class << self
    
    #Shows a message box to the user.
    #==Parameters
    #[caption] The box's caption.
    #[text]    The text to display.
    #[parent]  (nil) A parent window's handle.
    #[*styles] An array of symbols formed off the constants
    #          in the Automations::WinWrappers::Constants module
    #          that begin with "MB_", e.g. the MB_OK constant
    #          gives you a :ok symbol you can pass here. Useful
    #          symbols include:
    #          [:ok] "OK" button.
    #          [:yesno] "Yes" and "no" buttons.
    #          [:yesnocancel] "Yes", "no" and "cancel" buttons.
    #          [:okcancel] "OK" and "cancel" buttons.
    #          [:retrycancel] "Retry" and "cancel" buttons.
    #          [:iconinformation] "i" icon.
    #          [:iconwarning] "!" icon.
    #          [:iconquestion] "?" icon.
    #          [:iconerror] "X" icon.
    #          Defaults to an "OK" button without an icon.
    #==Return value
    #A symol like :abort or :ok, fitting to one the constants
    #whose names begin with "ID". The possible symbols can be
    #determined from the +styles+ argument as well (so a :yesno
    #style can only result in :yes and :no symbols being returned).
    #==Example
    #  # Plain box without anything.
    #  Misc.msgbox("Title", "text")
    #  
    #  # Question with Yes and No buttons and a question icon
    #  res = Misc.msgbox("Question",  "Delete your harddrive?", nil, :yesno, :iconquestion)
    #  if res == :yes
    #    # ...
    #  else
    #    # ...
    #  end
    def msgbox(caption, text, parent = nil, *styles)
      style = styles.inject(0) do |res, sym| 
        res | (C.const_get(:"MB_#{sym.upcase}") || raise(ArgumentError, "Unknown style #{sym}!"))
      end
      
      res = F.message_box(parent, wide_str(text), wide_str(caption), style)
      case res
      when C::IDABORT    then :abort
      when C::IDCANCEL   then :cancel
      when C::IDCONTINUE then :continue
      when C::IDIGNORE   then :ignore
      when C::IDNO       then :no
      when C::IDOK       then :ok
      when C::IDRETRY    then :retry
      when C::IDTRYAGAIN then :tryagain
      when C::IDYES      then :yes
      else
        res
      end
    end

  end

end
