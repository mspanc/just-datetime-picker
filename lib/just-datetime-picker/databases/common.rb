module Just
  module DateTimePicker
    module DatabaseAbstraction
      module Common
        extend ActiveSupport::Concern
        
        class JustDateValidator < ActiveModel::EachValidator
          def validate_each(record, attribute, value)
            return if value.nil?
            return if value.to_s.empty?
            
            begin
              Date.parse(value)
            rescue ArgumentError
              if defined?(Mongoid) and record.class.included_modules.include? Mongoid::Document
                record.errors[attribute] << I18n.t("mongoid.errors.messages.just_datetime_invalid_date")
              else
                record.errors[attribute] << I18n.t("activerecord.errors.messages.just_datetime_invalid_date")
              end
            end
          end
        end

        included do
          # Defines attribute specified as +field_name+ as field that will
          # be underlying storage for Just Date/Time Picker.
          #
          # It should accept saving values of type +ActiveSupport::TimeWithZone+.
          #
          # You can pass options by passing a Hash to the +options+ parameter.
          # Currently the only supported option is +:add_to_attr_accessible+
          # which if set to +true+ automatically calls +attr_accessible+ for
          # attribute passed as +field_name+ and all virtual attributes created
          # by Just Date/Time Picker.
          #
          # * *Arguments*    :
          #   - +field_name+ -> attribute to turn into +Just Date/Time Picker+ storage
          #   - +options+ -> +Hash+ with options
          #     - +:add_to_attr_accessible+ -> call automatically attr_accessible for attributes? (+boolean+)
          # 
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
              if v.to_s.empty?
                instance_variable_set("@#{field_name}_date", nil)
              else
                instance_variable_set("@#{field_name}_date", v)
              end
              
              just_combine_datetime field_name
            end

            define_method "#{field_name}_time_hour=" do |v|
              if v.to_s.empty?
                instance_variable_set("@#{field_name}_time_hour", nil)
              else
                instance_variable_set("@#{field_name}_time_hour", v.to_i)
              end
              
              just_combine_datetime field_name
            end
            
            define_method "#{field_name}_time_minute=" do |v|
              if v.to_s.empty?
                instance_variable_set("@#{field_name}_time_minute", nil)
              else
                instance_variable_set("@#{field_name}_time_minute", v.to_i)
              end
              
              just_combine_datetime field_name
            end
            
            if options.has_key? :add_to_attr_accessible and options[:add_to_attr_accessible] == true
              attr_accessible "#{field_name}_date".to_sym, "#{field_name}_time_hour".to_sym, "#{field_name}_time_minute".to_sym
            end
          end # just_define_datetime_picker

          protected

          # Combines values passed to individual fields (date, hour and minutes) into syntax acceptable by DB.
          #
          # It performs validation by trying to parse combined time. In case of error it just logs warning.
          # In such case, stored date/time remains unchanged.
          #
          # It performs and tries to store the value only if all components (date, hour and minutes) are set.
          # Otherwise it checks the opposite - if maybe all values are nil, and then sets NULL in the DB if
          # this condition is true.
          #
          # * *Arguments*    :
          #   - +field_name+ -> attribute that is used to represent +Just Date/Time Picker+ storage
          def just_combine_datetime(field_name)
            if instance_variable_get("@#{field_name}_date").nil?
                self.send("#{field_name}=", '')
            end
            if not instance_variable_get("@#{field_name}_date").nil? and not instance_variable_get("@#{field_name}_time_hour").nil? and not instance_variable_get("@#{field_name}_time_minute").nil?

              combined = "#{instance_variable_get("@#{field_name}_date")} #{sprintf("%02d", instance_variable_get("@#{field_name}_time_hour"))}:#{sprintf("%02d", instance_variable_get("@#{field_name}_time_minute"))}:00"
              begin
                self.send("#{field_name}=", Time.zone.parse(combined))

              rescue ArgumentError
                logger.warn "Just error while trying to set #{field_name} attribute: \"#{combined}\" is not valid date/time"
              end
            
            elsif instance_variable_get("@#{field_name}_date").nil? and instance_variable_get("@#{field_name}_time_hour").nil? and instance_variable_get("@#{field_name}_time_minute").nil?
              self.send("#{field_name}=", nil)              
            end
          end
        end # included

        
      end
    end
  end
end


