puts "LOADED MONGOID"

Mongoid::Document.send :include, Just::DateTimePicker::DatabaseAbstraction::Common

