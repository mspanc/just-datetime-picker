module Formtastic
    module Inputs
    class JustDatetimePickerInput 
      include ::Formtastic::Inputs::Base

      def time_input
          options[:time_input] || :text_field
      end

      def hour_options
          am = I18n.t("time.period.am")
          pm = I18n.t("time.period.pm")
          return {
              "12 #{am}" => "00",
              "1 #{am}"  => "01",
              "2 #{am}"  => "02",
              "3 #{am}"  => "03",
              "4 #{am}"  => "04",
              "5 #{am}"  => "05",
              "6 #{am}"  => "06",
              "7 #{am}"  => "07",
              "8 #{am}"  => "08",
              "9 #{am}"  => "09",
              "10 #{am}" => "10",
              "11 #{am}" => "11",
              "12 #{pm}" => "12",
              "1 #{pm}"  => "13",
              "2 #{pm}"  => "14",
              "3 #{pm}"  => "15",
              "4 #{pm}"  => "16",
              "5 #{pm}"  => "17",
              "6 #{pm}"  => "18",
              "7 #{pm}"  => "19",
              "8 #{pm}"  => "20",
              "9 #{pm}"  => "21",
              "10 #{pm}" => "22",
              "11 #{pm}" => "23",
          } if options[:hours_12]
          ("00".."23")
      end

      def minute_options
          minutes = ("00".."59")
          options[:minute_step] ? minutes.step(options[:minute_step]) : minutes
      end

      def number_step
          options[:minute_step] || 1
      end

      def to_html
        input_wrapping do
          combined_value = builder.object.send(method)
          
          hour_value_raw = builder.object.send("#{method}_time_hour")
          if not hour_value_raw.nil?
            hour_value = hour_value_raw
          elsif not combined_value.nil?
            hour_value = combined_value.hour
          else
            hour_value = "00"
          end

          minute_value_raw = builder.object.send("#{method}_time_minute")
          if not minute_value_raw.nil?
            minute_value = minute_value_raw
          elsif not combined_value.nil?
            minute_value = combined_value.min
          else
            minute_value = "00"
          end

          hour_value   = sprintf("%02d", hour_value)
          minute_value = sprintf("%02d", minute_value)

          time_html         = ""
          hour_dom_name     = "#{method}_time_hour"
          minute_dom_name   = "#{method}_time_minute"
          base_dom_classes  = "just-datetime-picker-field just-datetime-picker-time"
          hour_dom_class    = "just-datetime-picker-time-hour"
          minute_dom_class  = "just-datetime-picker-time-minute"

          case time_input
          when :select
              time_html <<
              builder.select("#{hour_dom_name}", hour_options, {:selected => hour_value}, input_html_options.merge({
                  :class => "#{base_dom_classes} #{hour_dom_class}",
                  :value => hour_value
              })) <<
              ":" <<
              builder.select("#{minute_dom_name}", minute_options, {:selected => minute_value}, input_html_options.merge({
                  :class => "#{base_dom_classes} #{minute_dom_class}",
                  :value => hour_value
              }))
          when :number
              time_html <<
              builder.number_field("#{hour_dom_name}", input_html_options.merge({ 
                  :class => "#{base_dom_classes} #{hour_dom_class}", 
                  :value => hour_value, :min => 0,  :max => 23 
              })) <<
              ":" <<
              builder.number_field("#{minute_dom_name}", input_html_options.merge({ 
                  :class => "#{base_dom_classes} #{minute_dom_class}", 
                  :value => minute_value, :min => 0, :max => 59, :step => number_step
              }))
          else
              time_html <<
              builder.text_field("#{hour_dom_name}", input_html_options.merge({ 
                  :class => "#{base_dom_classes} #{hour_dom_class}", 
                  :value => hour_value, :maxlength => 2, :size => 2
              })) <<
              ":" <<
              builder.text_field("#{minute_dom_name}", input_html_options.merge({ 
                  :class => "#{base_dom_classes} #{minute_dom_class}", 
                  :value => minute_value, :maxlength => 2, :size => 2
              }))
          end

          label_html <<
          builder.text_field("#{method}_date", input_html_options.merge({ 
              :class => "just-datetime-picker-field just-datetime-picker-date datepicker", 
              :value => builder.object.send("#{method}_date"), :maxlength => 10, :size => 10 
          })) <<
          time_html.html_safe
        end
      end
    end
  end
end
