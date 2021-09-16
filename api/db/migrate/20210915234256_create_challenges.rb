class CreateChallenges < ActiveRecord::Migration[6.0]
  def change
    create_table :challenges do |t|
      t.string :title, null: false
      t.text :detail, null: false
      t.integer :continuation, null: false
      t.integer :goal, null: false
      t.integer :cleared, null: false
      t.boolean :is_started, null: false
      t.boolean :is_done, null: false
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
