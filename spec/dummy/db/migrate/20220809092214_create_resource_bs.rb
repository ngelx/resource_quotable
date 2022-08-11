# frozen_string_literal: true

class CreateResourceBs < ActiveRecord::Migration[6.1]
  def change
    create_table :resource_bs do |t|
      t.string :name

      t.timestamps
    end
  end
end
