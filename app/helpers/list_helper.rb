module ListHelper

  def list_group(collection, options={}, &block)
    fields_content = collection.map{|model| list_group_item(model, options, &block)}.join.html_safe

    if options[:wrap] === false
      fields_content
    else
      content_tag :div, fields_content, class: "list-group #{options[:class]}"
    end
  end

  def list_group_fields(options={})
    fields = options[:fields].keep_if{|k,v| v.present?}
    object = options[:object]
    fields.map{|field, value| list_group_field(object, field, value) }.join.html_safe
  end

  def list_group_item(model, options={}, &block)
    if (link = options[:url])
      link_to (link === true ? model : link), class: "list-group-item clearfix size-xs-small size-sm-normal list-group-item-action #{options[:class]}" do
        capture(model, &block) if block_given?
      end
    else
      content_tag :div, class: "list-group-item clearfix size-xs-small size-sm-normal #{options[:class]}" do
        capture(model, &block) if block_given?
      end
    end
  end

  def list_group_field(object, field, value=nil, &block)
    value = capture(&block) if block_given?
    html = <<-HTML
      <div class="list-group-item">
        <div class="row">
          <div class="col-sm-4 text-light size-xs-small size-sm-normal">#{ field_name(object, field) }</div>
          <div class="col-sm-8">#{ h value }</div>
        </div>
      </div>
    HTML
    html.html_safe
  end

  def by_first_letter(list)
    list.sort_by(&:name).group_by { |item| item.name[0].upcase }
  end

  def by_date(list)
    list.sort_by(&:checked_in_at).group_by{|checkin| checkin.checked_in_at.strftime('%-d %b %Y')}.sort.reverse
  end

  def by_age_range(people)
    people.select(:dob).to_a.reduce({'N/A' => 0, '0-4' => 0, '5-1' => 0, '12-17' => 0, '18-25' => 0, '26-35' => 0, '36-50' => 0, '51+' => 0}){|memo, person|
      years = person.years_old
      key = if years.nil?
              'N/A'
            elsif years <= 4
              '0-4'
            elsif years <= 11
              '5-1'
            elsif years <= 17
              '12-17'
            elsif years <= 25
              '18-25'
            elsif years <= 35
              '26-35'
            elsif years <= 50
              '36-50'
            else
              '51+'
            end
      memo[key] += 1
      memo
    }
  end

  def by_gender(people)
    people.select(:gender).group(:gender).count('*').map{|k,v|
      if k == 'm'
        ['Male', v]
      elsif k == 'f'
        ['Female', v]
      else
        ['Unknown', v]
      end
    }.to_h
  end
end
