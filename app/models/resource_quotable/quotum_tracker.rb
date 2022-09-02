# == Schema Information
#
# Table name: resource_quotable_quotum_trackers
#
#  id        :integer          not null, primary key
#  counter   :integer          default(0), not null
#  flag      :boolean          default(FALSE), not null
#  quotum_id :integer          not null
#  user_id   :integer          not null
#
# Indexes
#
#  index_resource_quotable_quotum_trackers_on_quotum_id  (quotum_id)
#  index_resource_quotable_quotum_trackers_on_user_id    (user_id)
#  resource_quotable_quotum_trackers_unique_index        (user_id,quotum_id) UNIQUE
#

# frozen_string_literal: true

module ResourceQuotable
  # Flag is true when the quota has been reached.
  class QuotumTracker < ApplicationRecord
    belongs_to :quotum
    belongs_to :user, class_name: ResourceQuotable.user_class.to_s

    validates :counter, presence: true

    scope :with_active_counter, -> { where('counter > 0') }
    scope :quotum_for, ->(action, resource) { where(action: action, resource_class: resource) }
    scope :under_limit, ->(limit_to_check_against) { where('counter < ?', limit_to_check_against) }
    scope :over_limit, ->(limit_to_check_against) { where('counter >= ?', limit_to_check_against) }
    scope :flagged, -> { where(flag: true) }
    scope :not_flagged, -> { where(flag: false) }

    delegate :action, :resource_class, :limit, to: :quotum

    def increment!
      raise ResourceQuotable::QuotaLimitError if flag

      new_counter = counter + 1
      update(counter: new_counter, flag: (new_counter >= limit))
    end

    def reset!
      return if counter.zero?

      self.counter = 0
      self.flag = (counter >= limit)
      save
    end
  end
end
