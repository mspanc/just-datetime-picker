require 'formtastic'

module Just
  module DateTime
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        # Add load paths straight to I18n, so engines and application can overwrite it.
        require 'active_support/i18n'
        
        $stderr.puts "ADDING I18n: #{File.expand_path('../just-datetime-picker/locales/*.yml', __FILE__)}"
        I18n.load_path += Dir[File.expand_path('../just-datetime-picker/locales/*.yml', __FILE__)]
      end
    end
  end
end

require 'just-datetime-picker/core'
require 'just-datetime-picker/activerecord'
require 'just-datetime-picker/formtastic-input'

