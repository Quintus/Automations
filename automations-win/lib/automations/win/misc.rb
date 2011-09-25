# -*- coding: utf-8 -*-

require_relative "../win"

#This module contains all the methods that didn't fit into other
#scopes.
module Automations::Win::Misc
  extend Automations::Win::Utilities
  
  class << self
    include Automations::Win::Utilities
    include Automations::Win::Wrappers
    
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
        res | (Constants.const_get(:"MB_#{sym.upcase}") || raise(ArgumentError, "Unknown style #{sym}!"))
      end
      
      res = Functions.scall(:message_box, parent, wide_str(text), wide_str(caption), style)
      case res
      when Constants::IDABORT    then :abort
      when Constants::IDCANCEL   then :cancel
      when Constants::IDCONTINUE then :continue
      when Constants::IDIGNORE   then :ignore
      when Constants::IDNO       then :no
      when Constants::IDOK       then :ok
      when Constants::IDRETRY    then :retry
      when Constants::IDTRYAGAIN then :tryagain
      when Constants::IDYES      then :yes
      else
        res
      end
    end

    #Reads a specific system attribute.
    #==Parameter
    #[sym] The symbol of the parameter to read. Possible symbols can be
    #      derived from the Automations::Win::Wrappers::Constants::SM_* 
    #      constants.
    #==Return value
    #The specified metric.
    #==Example
    #  # Get the screen width. The constant you find is SM_CXSCREEN,
    #  # therefore the symbol you have to use is :cxsreen.
    #  Misc.system_metric(:cxscreen) #=> 1024
    #==Remarks
    #A comprehensive description of the possible system metrics can be
    #found in MSDN's documentation of the <tt>GetSystemMetrics()</tt>
    #function: http://msdn.microsoft.com/en-us/library/ms724385%28v=VS.85%29.aspx .
    #
    #Note that this method doesn't raise SystemCallErrors, because the
    #0 usually indicating function failure can actually be a valid
    #metric value.
    def system_metric(sym)
      const = :"SM_#{sym.upcase}"
      raise(ArgumentError, "Unknown metric #{sym}!") unless Constants.const_defined?(const)
      
      val = Constants.const_get(const)
      Functions.get_system_metrics(Constants.const_get(const))
    end

  end

end
