module AlertsHelper
  def flash_messages(args={})
    return if @shown_flash_messages
    @shown_flash_messages = true

    if flash[:alert]
      html = content_tag :div, flash[:alert],   class: "alert alert-danger #{args[:class]}"
    elsif flash[:info]
      html = content_tag :div, flash[:info],    class: "alert alert-info #{args[:class]}"
    elsif flash[:notice]
      html = content_tag :div, flash[:notice],  class: "alert alert-info #{args[:class]}"
    elsif flash[:success]
      html = content_tag :div, flash[:success], class: "alert alert-success #{args[:class]}"
    else
      return
    end

    html = content_tag :div, html, class: args[:container] if args[:container]
    html
  end
end
