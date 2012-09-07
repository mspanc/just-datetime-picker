module Just
  module DateTime
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

        desc "Installs Just DateTime Picker"
        def copy__file
          copy_file 'just_datetime.css', 'app/assets/stylesheets/just_datetime.css'
        end
      end
    end
  end
end
