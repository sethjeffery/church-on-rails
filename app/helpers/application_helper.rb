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

  # Wraps content in a <div class="fa-container"></div> and adds an icon, for convenience.
  # Like typical view helpers, this method can take two forms, block or string content.
  #
  #  @example String syntax
  #    fa_container("Content", "icon", { ... })
  #
  #  @example Block syntax
  #    fa_container("icon", { ... })  do "Content" end
  #
  def fa_container(content_or_icon, icon_or_args={}, args={}, &block)
    if icon_or_args.is_a?(Hash)
      args = icon_or_args
      icon_or_args = content_or_icon
      content_or_icon = capture(&block)
    end
    content_tag((args[:tag] || :div), args.merge(class: "fa-container #{args[:class]}")) { fa_icon(icon_or_args) << content_or_icon }
  end

  def field_name(object, method)
    ActionView::Helpers::Tags::Translator.new(object, object.class.name.underscore, method, scope: "helpers.label").translate
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
