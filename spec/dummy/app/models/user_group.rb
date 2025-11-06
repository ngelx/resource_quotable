# == Schema Information
#
# Table name: user_groups
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#
class UserGroup < ApplicationRecord
  acts_as_quotable

  has_many :admin_users
end
