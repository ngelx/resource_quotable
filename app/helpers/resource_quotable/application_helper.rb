# frozen_string_literal: true

module ResourceQuotable
  module ApplicationHelper # :nodoc:
    def resource_quotable
      content_tag(:div, '', id: 'resource_quotable_content')
    end
  end
end
