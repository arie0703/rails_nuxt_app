class AddDoneAtToChallenges < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :done_at, :date
  end
end
