module GraphHelper
  def pictograph(count, icon, fa_class = '2x')
    icons = (1..count.to_i).to_a.map{|number|
      icon_for icon, fa_class, 'pictograph', class: 'mr-xs'
    }

    if count % 1 > 0.05
      width = (count % 1)
      final = content_tag(:span, class: "fa fa-#{fa_class} fa-pictograph fa-stack mr-xs") do
        icon_for(icon, '1x pictograph stack-1x', class: 'text-lighter') +
          content_tag(:span, class: 'fa fa-1x fa-pictograph fa-stack-1x', style: "width: #{width}em; overflow: hidden;") do
            icon_for(icon, '1x pictograph stack-1x')

        end
      end
      icons << final
    end

    icons.join('').html_safe
  end
end
