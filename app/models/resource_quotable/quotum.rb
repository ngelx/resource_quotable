# == Schema Information
#
# Table name: resource_quotable_quota
#
#  id             :integer          not null, primary key
#  action         :integer
#  flag           :boolean
#  resource_class :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_resource_quotable_quota_on_user_id  (user_id)
#

module ResourceQuotable
  class Quotum < ApplicationRecord
    belongs_to :user, class_name: ResourceQuotable.user_class.to_s
    has_many :quotum_limits, dependent: :destroy

    validates :resource_class, :action, presence: true
  end
end
