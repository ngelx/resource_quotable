# frozen_string_literal: true

class CreateAdminUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :admin_users do |t|
      t.references :user_group, null: false, foreign_key: true

      t.string :username

      t.timestamps
    end
  end
end
