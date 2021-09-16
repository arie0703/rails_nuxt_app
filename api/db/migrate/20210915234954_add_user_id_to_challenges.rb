class AddUserIdToChallenges < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :user_id, :integer
  end
end
