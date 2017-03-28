module BrowserHelper
  def can_autofocus?
    !browser.device.mobile? && !browser.device.tablet?
  end
end
