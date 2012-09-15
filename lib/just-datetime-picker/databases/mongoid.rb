module Just
  module DateTimePicker
    module DatabaseAbstraction
      module Mongoid
        extend ActiveSupport::Concern
        extend Common
      end
    end
  end
end

Mongoid::Document.send :include, Just::DateTimePicker::DatabaseAbstraction::Mongoid

