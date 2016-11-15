module AlertsHelper
  def flash_messages
    if flash[:alert]
      html = <<-HTML
        <div class="alert alert-danger">
          #{flash[:alert]}
        </div>
      HTML
      html.html_safe
    elsif flash[:info]
      html = <<-HTML
        <div class="alert alert-info">
          #{flash[:info]}
        </div>
      HTML
      html.html_safe
    elsif flash[:notice]
      html = <<-HTML
        <div class="alert alert-info">
          #{flash[:notice]}
        </div>
      HTML
      html.html_safe
    elsif flash[:success]
      html = <<-HTML
        <div class="alert alert-success">
          #{flash[:success]}
        </div>
      HTML
      html.html_safe
    end
  end
end
