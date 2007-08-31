require 'resourceful/builder'

module Resourceful
  module Serialize
    module Model

      def serialize(format, options = {})
        hash = self.to_hash(options[:attributes])
        root = self.class.to_s.underscore
        if format == :xml
          hash.send("to_#{format}", :root => root)
        else
          {root => hash}.send("to_#{format}")
        end
      end

      def to_hash(attributes = nil)
        attributes = normalize_attributes(attributes)
        return self.attributes if attributes.nil?

        attributes.inject({}) do |hash, (key, value)|
          attr = self.send(key)
          attr = attr.to_hash(value) if ActiveRecord::Base === attr

          # Would use Array === attr here,
          # but it's not overridden for associations
          attr.map! { |e| e.to_hash(value) } if attr.is_a?(Array) && ActiveRecord::Base === attr.first
          hash[key.to_s] = attr
          hash
        end
      end

      private
      
      def normalize_attributes(attributes)
        return nil if attributes.nil?
        return {attributes => nil} if !attributes.respond_to?(:inject)

        attributes.inject({}) do |hash, attr|
          if Array === attr
            hash[attr[0]] = attr[1]
            hash
          else
            hash.merge normalize_attributes(attr)
          end
        end
      end

    end

    module Array
      
      def serialize(format, options = {})
        raise "Not all elements respond to to_hash" unless all? { |e| e.respond_to? :serialize }

        serialized = map { |e| e.to_hash(options[:attributes]) }
        root = first.class.to_s.pluralize.underscore

        if format == :xml
          serialized.send("to_#{format}", :root => root)
        else
          {root => serialized}.send("to_#{format}")
        end
      end

    end
  end
end

class ActiveRecord::Base; include Resourceful::Serialize::Model; end
class Array; include Resourceful::Serialize::Array; end
