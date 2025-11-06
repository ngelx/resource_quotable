# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_users
#
#  id            :integer          not null, primary key
#  username      :string
#  created_at    :datetime
#  updated_at    :datetime
#  user_group_id :integer          not null
#
# Foreign Keys
#
#  user_group_id  (user_group_id => user_groups.id)
#
class AdminUser < ApplicationRecord
  acts_as_quota_trackable

  belongs_to :user_group
end
