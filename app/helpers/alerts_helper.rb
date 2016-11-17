module AlertsHelper
  def flash_messages(args={})
    if flash[:alert]
      html = content_tag :div, flash[:alert],   class: 'alert alert-danger'
    elsif flash[:info]
      html = content_tag :div, flash[:info],    class: 'alert alert-info'
    elsif flash[:notice]
      html = content_tag :div, flash[:notice],  class: 'alert alert-info'
    elsif flash[:success]
      html = content_tag :div, flash[:success], class: 'alert alert-success'
    else
      return
    end

    html = content_tag :div, html, class: args[:container] if args[:container]
    html
  end
end
