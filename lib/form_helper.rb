module ActionView
  module Helpers
    module Tags
      class DateSelect < Base

        # Render date_select using Bootstrap-DateTimePicker
        def render_as_text(options = {})
          options = @options.merge(options).stringify_keys
          options["size"] = options["maxlength"] unless options.key?("size")
          options["type"] = 'text'
          options["class"] ||= "form-control"
          options["data"] = (options["data"] || {}).stringify_keys
          options["data"]["datetimepicker"] = true
          options["value"] = options.fetch("value") { value_before_type_cast(object) }
          add_default_name_and_id(options)

          text_tag = "<input#{tag_options(options, true) if options}/>".html_safe

          if options["icon"]
            label_tag = content_tag_string(:label, content_tag_string(:i, '', class: "fa fa-1x #{options["icon"].gsub(/\b([\w\-_]+)\b/, "fa-\\1")}"), class: 'input-group-addon', for: options["id"])
            error_wrapping content_tag_string :div, text_tag + label_tag, class: 'input-group date'
          else
            error_wrapping text_tag
          end
        end

        def render
          render_as_text icon: 'calendar', data: { format: 'DD MMM YYYY' }, value: object.send(@method_name)&.strftime('%d %b %Y')
        end
      end

      class TimeSelect < DateSelect # :nodoc:
        def render
          render_as_text icon: 'clock-o', data: { format: 'HH:mm' }, value: object.send(@method_name)&.strftime('%H:%M')
        end
      end

      class DateTimeSelect < DateSelect # :nodoc:
        def render
          render_as_text icon: 'calendar', data: { format: 'DD MMM YYYY HH:mm' }, value: object.send(@method_name)&.strftime('%d %b %Y %H:%M')
        end
      end
    end
  end

  # Better field rendering for error fields
  Base.field_error_proc = Proc.new do |html_tag, instance|
    object = instance.instance_variable_get(:@object)
    options = instance.instance_variable_get(:@options)
    object_name = instance.instance_variable_get(:@object_name)
    method_name = instance.instance_variable_get(:@method_name)
    field_name = ActionView::Helpers::Tags::Translator.new(object, object_name, method_name, scope: "helpers.label").translate

    if options.stringify_keys["hide_errors"]
      html_tag
    else
      if html_tag =~ /^<label .+\/label>$/
        %(<div class="has-danger">#{html_tag}</div>).html_safe
      else
        if instance.error_message.kind_of?(Array)
          %(<div class="has-danger">#{html_tag}</div><div class="size-xs-tiny font-weight-normal text-danger my-xs">#{field_name} #{instance.error_message.uniq.join(', ')}</div>).html_safe
        else
          %(<div class="has-danger">#{html_tag}</div><div class="size-xs-tiny font-weight-normal text-danger my-xs">#{field_name} #{instance.error_message}</div>).html_safe
        end
      end
    end
  end
end
