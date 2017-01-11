module AlertsHelper
  def flash_messages(args={})
    return if @shown_flash_messages
    @shown_flash_messages = true

    if flash[:alert] && (!args[:only] || args[:only] == :alert)
      html = content_tag :div, flash[:alert],   class: "alert alert-danger #{args[:class]}"

    elsif flash[:info] && (!args[:only] || args[:only] == :info)
      html = content_tag :div, flash[:info],    class: "alert alert-info #{args[:class]}"

    elsif flash[:notice] && (!args[:only] || args[:only] == :notice)
      html = content_tag :div, flash[:notice],  class: "alert alert-info #{args[:class]}"

    elsif flash[:success] && (!args[:only] || args[:only] == :success)
      html = content_tag :div, flash[:success], class: "alert alert-success #{args[:class]}"

    else
      return
    end

    html = content_tag :div, html, class: args[:container] if args[:container]
    html
  end
end
