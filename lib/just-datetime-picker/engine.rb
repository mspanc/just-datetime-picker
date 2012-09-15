module Just
  module DateTimePicker
    class Engine < Rails::Engine
      if Rails.version >= "3.1"
        initializer "Just DateTime Picker precompile hook" do |app|
          app.config.assets.precompile += %w(just_datetime_picker/base.css just_datetime_picker/nested_form_workaround.js)
        end
      end
    end
  end
end

