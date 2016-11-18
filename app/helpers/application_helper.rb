module ApplicationHelper
  def side_menu?
    user_signed_in?
  end

  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
    }

    extensions = {
      disable_indented_code_blocks: true,
      fenced_code_blocks:  true,
      no_intra_emphasis:   true,
      strikethrough:       true,
      space_after_headers: true,
      autolink:            true,
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    content_tag :div, markdown.render(text).html_safe, class: 'markdown-container'
  end

end
