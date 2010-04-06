# ValidatesIncrementalOf
module ActiveRecord
  module Validations
    module ClassMethods
      def validates_positive_number_of(*attr_names)
        configuration = {:on => :save}
        configuration.update(attr_names.extract_options!)
        validates_each(attr_names, configuration) do |record, attr_name, value|
          record.errors.add(attr_name, 'must be positive number') if value <= 0
        end
      end
      
      def validates_incremental_of(*attr_names)
        configuration = { :on => :update }
        configuration.update(attr_names.extract_options!)
        validates_each(attr_names, configuration) do |record, attr_name, value|
          changed = "#{attr_name}_changed?"
          change = "#{attr_name}_change"
          if record.send(changed) && record.send(change).first > record.send(change).last
            record.errors.add(attr_name, 'must be incremental')
          end
        end
      end
    end
  end
end
