# frozen_string_literal: true

class CreateResourceQuotableQuota < ActiveRecord::Migration[4.2] # :nodoc:
  def change
    create_table :resource_quotable_quota do |t|
      t.integer :group_id, null: false, index: true
      t.string :group_type, null: false
      t.string :resource_class, null: false
      t.integer :action, null: false, default: 0
      t.integer :period, null: false, default: 0
      t.integer :limit, null: false, default: 1

      t.timestamps
    end
    add_index :resource_quotable_quota, %i[group_id resource_class action period], unique: true, name: 'resource_quotable_quota_unique_index'
  end
end
