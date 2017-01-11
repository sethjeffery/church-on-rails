module ApplicationHelper
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

  def field_name(object, method)
    ActionView::Helpers::Tags::Translator.new(object, object.class.name.underscore, method, scope: "activerecord.attributes").translate
  end

  def field_help(object, method)
    ActionView::Helpers::Tags::Translator.new(object, object.class.name.underscore, method, scope: "activerecord.help").translate
  end

  def field_error(object, method)
    if object && object.errors[method].present?
      content_tag :div, class: "size-xs-tiny font-weight-normal text-danger my-xs" do
        field_name(object, method) << ' ' << object.errors[method].uniq.join(', ')
      end
    end
  end
end
