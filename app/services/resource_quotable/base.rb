# frozen_string_literal: true

module ResourceQuotable
  class Base # :nodoc:
    include ActiveModel::Validations

    def initialize(args = {})
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def self.call(args = {})
      service = new(args)
      raise ArgumentError, service.errors.full_messages.join(', ') if service.invalid?

      service.call
    end

    def call
      raise ResourceQuotable::AbstractClassError
    end
  end
end
