module IconsHelper
  # Given a resource name or instance (e.g. :person, :family, Team, ChurchProcess),
  # returns the Font-Awesome icon name used for that resource.
  #
  # You can send it a symbol or string, or a model instance, or a model class.
  #
  # This is useful because it means that at any time we can change the icon
  # representation of any model, or even the icon library that we use.
  #
  def icon_name_for(resource)
    resource = resource.name if resource.is_a? Class
    resource = resource.icon if resource.respond_to?(:icon)
    resource = resource.class.name unless resource.is_a?(String) || resource.is_a?(Symbol)
    resource = resource.to_s.underscore

    case resource.singularize.to_sym
      # models
      when :user then 'user-circle-o'
      when :church then 'home'
      when :person then 'user'
      when :team  then 'users'
      when :family then 'address-card'
      when :church_process then 'arrow-right'
      when :person_process then 'arrow-right'
      when :event then 'calendar'
      when :child_group then 'child'
      when :comment then 'comment'

      # other common nouns
      when :x then 'times'
      when :facebook then 'facebook-square'
      when :twitter then 'twitter-square'
      when :process then 'arrow-right'
      when :email then 'envelope'
      when :password then 'lock'
      when :edit then 'pencil'

      # treat anything left as a FontAwesome icon name
      else resource.dasherize
    end
  end

  # Given a resource name or instance (e.g. :person, :family, Team, ChurchProcess),
  # generates an icon tag that can be rendered on the page. You can provide as many
  # extra options for Font-Awesome and also a hash of standard tag attributes.
  #
  # You can send it a symbol or string, or a model instance, or a model class.
  #
  def icon_for(resource, *extras)
    args = {}
    args = extras.pop if extras.last.is_a?(Hash)
    icon = icon_name_for(resource) + (extras.present? ? ' ' + extras.join(' ') : '')
    fa_icon icon, args
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
    content_tag((args[:tag] || :div), args.merge(class: "fa-container #{args[:class]}")) { icon_for(icon_or_args) << content_or_icon }
  end
end
