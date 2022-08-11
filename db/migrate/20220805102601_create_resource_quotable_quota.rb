# frozen_string_literal: true

class CreateResourceQuotableQuota < ActiveRecord::Migration[6.1] # :nodoc:
  def change
    create_table :resource_quotable_quota do |t|
      t.integer :user_id, null: false, index: true
      t.text :resource_class, null: false
      t.integer :action, null: false, default: 0
      t.boolean :flag

      t.timestamps
    end
  end
end
