=begin
module Just
  module DateTime
    class Engine < Rails::Engine
      if Rails.version > "3.1"
        initializer "Just DateTime precompile hook" do |app|
          app.config.assets.precompile += %w(just_datetime.css)
        end
      end
    end
  end
end
=end
