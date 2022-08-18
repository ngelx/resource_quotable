# frozen_string_literal: true

# rubocop:disable Rails/CreateTableWithTimestamps

class CreateResourceQuotableQuotumLimits < ActiveRecord::Migration[6.1] # :nodoc:
  def change
    create_table :resource_quotable_quotum_limits do |t|
      t.integer :quotum_id, null: false, index: true
      t.integer :limit, null: false, default: 1
      t.integer :period, null: false, default: 0
      t.boolean :flag, null: false, default: false
      t.integer :counter, null: false, default: 0
    end
    add_index :resource_quotable_quotum_limits, %i[quotum_id period], unique: true
  end
end

# rubocop:enable Rails/CreateTableWithTimestamps
