# frozen_string_literal: true

class CreateResourceAs < ActiveRecord::Migration[6.1]
  def change
    create_table :resource_as do |t|
      t.string :name

      t.timestamps
    end
  end
end
