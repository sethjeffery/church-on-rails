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

          text_tag = tag(:input, options)

          if options["icon"]
            label_tag = content_tag(:label, content_tag(:i, '', class: "fa fa-1x #{options["icon"].gsub(/\b([\w\-_]+)\b/, "fa-\\1")}"), class: 'input-group-addon', for: options["id"])
            content_tag :div, text_tag + label_tag, class: 'input-group date'
          else
            text_tag
          end
        end

        def render
          render_as_text icon: 'calendar', data: { format: 'DD MMM YYYY' }
        end
      end

      class TimeSelect < DateSelect # :nodoc:
        def render
          render_as_text icon: 'clock-o', data: { format: 'HH:mm' }
        end
      end

      class DateTimeSelect < DateSelect # :nodoc:
        def render
          render_as_text icon: 'calendar', data: { format: 'HHDD MMM YYYY HH:mm' }
        end
      end
    end
  end
end
