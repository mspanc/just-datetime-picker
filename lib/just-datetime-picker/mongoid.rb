module JustDatetimePicker
    module Mongoid
      extend ActiveSupport::Concern
      class JustDateValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          begin
            Date.parse(value)
          rescue ArgumentError
            record.errors[attribute] << I18n.t("mongoid.errors.messages.just_datetime_invalid_date")
          end
        end
      end

      included do
        def self.just_define_datetime_picker(field_name, options = {})

          attr_reader "#{field_name}_time_hour"
          attr_reader "#{field_name}_time_minute"

          validates "#{field_name}_date",        :just_date => true, :allow_nil => true, :allow_blank => false
          validates "#{field_name}_time_hour",   :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 23, :message => :just_datetime_invalid_time_hour }, :allow_nil => true, :allow_blank => false
          validates "#{field_name}_time_minute", :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 59, :message => :just_datetime_invalid_time_minute }, :allow_nil => true, :allow_blank => false

          after_validation do
            date_attribute   = "#{field_name}_date".to_sym
            hour_attribute   = "#{field_name}_time_hour".to_sym
            minute_attribute = "#{field_name}_time_minute".to_sym
            hour_value       = self.send(hour_attribute)
            minute_value     = self.send(minute_attribute)

            self.errors[hour_attribute].each{ |e| self.errors[field_name] << e }
            self.errors[minute_attribute].each{ |e| self.errors[field_name] << e }
            self.errors[date_attribute].each{ |e| self.errors[field_name] << e }

            self.errors[field_name].uniq!
          end


          define_method "#{field_name}_date" do
            return instance_variable_get("@#{field_name}_date") if instance_variable_get("@#{field_name}_date")
            return nil if self.send(field_name).nil?

            self.send(field_name).to_date.to_s
          end

          define_method "#{field_name}_date=" do |v|
            instance_variable_set("@#{field_name}_date", v)
            just_combine_datetime field_name
          end

          define_method "#{field_name}_time_hour=" do |v|
            instance_variable_set("@#{field_name}_time_hour", v.to_i)
            just_combine_datetime field_name
          end

          define_method "#{field_name}_time_minute=" do |v|
            instance_variable_set("@#{field_name}_time_minute", v.to_i)
            just_combine_datetime field_name
          end


          if options.has_key? :add_to_attr_accessible and options[:add_to_attr_accessible] == true
            attr_accessible "#{field_name}_date".to_sym, "#{field_name}_time_hour".to_sym, "#{field_name}_time_minute".to_sym
          end
        end # just_define_datetime_picker


        protected
        def just_combine_datetime(field_name)
          if not instance_variable_get("@#{field_name}_date").nil? and not instance_variable_get("@#{field_name}_time_hour").nil? and not instance_variable_get("@#{field_name}_time_minute").nil?

            combined = "#{instance_variable_get("@#{field_name}_date")} #{sprintf("%02d", instance_variable_get("@#{field_name}_time_hour"))}:#{sprintf("%02d", instance_variable_get("@#{field_name}_time_minute"))}:00"
            begin
              self.send("#{field_name}=", Time.zone.parse(combined))

            rescue ArgumentError
              logger.warn "Just error while trying to set #{field_name} attribute: \"#{combined}\" is not valid date/time"
            end
          end

        end
      end



    end
end

Mongoid::Document.send :include, JustDatetimePicker::Mongoid
