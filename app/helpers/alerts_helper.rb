module AlertsHelper
  def flash_messages(args={})
    if flash[:alert]
      html = <<-HTML
        <div class="alert alert-danger">
          #{flash[:alert]}
        </div>
      HTML

    elsif flash[:info]
      html = <<-HTML
        <div class="alert alert-info">
          #{flash[:info]}
        </div>
      HTML

    elsif flash[:notice]
      html = <<-HTML
        <div class="alert alert-info">
          #{flash[:notice]}
        </div>
      HTML

    elsif flash[:success]
      html = <<-HTML
        <div class="alert alert-success">
          #{flash[:success]}
        </div>
      HTML
    else
      html = ''
    end

    wrap_message(html, args)
  end

  def wrap_message(message, args={})
    if args[:container]
      "<div class='#{args[:container]}'>#{message}</div>".html_safe
    else
      message.html_safe
    end
  end
end
