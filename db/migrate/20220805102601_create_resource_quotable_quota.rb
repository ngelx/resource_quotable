# frozen_string_literal: true

class CreateResourceQuotableQuota < ActiveRecord::Migration[4.2] # :nodoc:
  def change
    create_table :resource_quotable_quota do |t|
      t.integer :user_id, null: false, index: true
      t.string :resource_class, null: false
      t.integer :action, null: false, default: 0
      t.boolean :flag, null: false, default: false

      t.timestamps
    end
    add_index :resource_quotable_quota, %i[user_id resource_class action], unique: true, name: 'resource_quotable_quota_unique_index'
  end
end
