class RemoveColumnsFromCards < ActiveRecord::Migration[6.0]
  def up
    remove_column :cards, :continuation
    remove_column :cards, :cleared
    remove_column :cards, :is_started
    remove_column :cards, :is_done
    remove_column :cards, :start_date
    remove_column :cards, :end_date
  end

  def down
    add_column :cards, :continuation, :integer
    add_column :cards, :cleared, :integer
    add_column :cards, :is_started, :boolean
    add_column :cards, :is_done, :boolean
    add_column :cards, :start_date, :date
    add_column :cards, :end_date, :date
  end
end
