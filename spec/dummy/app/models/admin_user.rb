# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_users
#
#  id         :integer          not null, primary key
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AdminUser < ApplicationRecord
  acts_as_quotable
end
