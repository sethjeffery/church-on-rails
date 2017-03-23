module MenuHelper
  def active_menu?(names)
    Array.wrap(names).any?{|name|
      if !name
        false
      elsif @person == current_person
        name.to_s == 'account'
      else
        content_for(:menu) == name.to_s
      end
    }
  end

  def menu_to(content, path={}, args={}, &block)
    if block_given?
      args = path
      path = content
      content_tag :div, class: "nav-item #{'active' if active_menu?(args[:menu])} #{args[:class]}" do
        link_to(path, class: 'nav-link', &block)
      end
    else
      content_tag :div, class: "nav-item #{'active' if active_menu?(args[:menu])} #{args[:class]}" do
        icon = args[:icon] ? icon_for(args[:icon], class: 'mr-sm hidden-lg-down') : h('')
        link_to(icon + content, path, class: 'nav-link', data: args[:data])
      end
    end
  end
end
