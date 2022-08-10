class CreateResourceQuotableQuota < ActiveRecord::Migration[6.1]
  def change
    create_table :resource_quotable_quota do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.text :resource_class
      t.integer :action
      t.boolean :flag

      t.timestamps
    end
  end
end
