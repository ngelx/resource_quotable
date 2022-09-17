# frozen_string_literal: true

# rubocop:disable Rails/CreateTableWithTimestamps
# No needs for timestamp here.
class CreateResourceQuotableQuotumTrackers < ActiveRecord::Migration[4.2] # :nodoc:
  def change
    create_table :resource_quotable_quotum_trackers do |t|
      t.integer :quotum_id, null: false, index: true
      t.integer :user_id, null: false, index: true
      t.string :user_type, null: false
      t.boolean :flag, null: false, default: false
      t.integer :counter, null: false, default: 0
    end
    add_index :resource_quotable_quotum_trackers, %i[user_id quotum_id], unique: true, name: 'resource_quotable_quotum_trackers_unique_index'
  end
end

# rubocop:enable Rails/CreateTableWithTimestamps
