class UserGroup < ApplicationRecord
  acts_as_quotable

  has_many :admin_users
end
