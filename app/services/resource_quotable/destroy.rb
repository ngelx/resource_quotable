# frozen_string_literal: true

module ResourceQuotable
  # Destroy Quota
  class Destroy < Base
    attr_accessor :quotum

    validates :quotum, presence: true

    def call
      quotum.destroy
    end
  end
end
