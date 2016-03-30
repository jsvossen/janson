class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id, index: true, foreign_key: true, null: false
      t.integer :friend_id, index: true, foreign_key: true, null: false
      t.string :status

      t.timestamps null: false
    end
    add_index :friendships, [:user_id, :friend_id], :unique => true
  end
end
