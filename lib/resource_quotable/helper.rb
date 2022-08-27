# frozen_string_literal: true

module ResourceQuotable
  module Helper # :nodoc:
    def resource_quotable
      content_tag(:div, '', id: ResourceQuotable.main_content)
    end

    def method_missing(method, *args, &block)
      if can_be_delegated?(method)
        main_app.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, *)
      can_be_delegated?(method) || super
    end

    protected

    def can_be_delegated?(method)
      (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
    end
  end
end
