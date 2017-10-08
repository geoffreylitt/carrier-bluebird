class AddBasicIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :tweets, :sync_id
    add_index :tweets, :twitter_id
  end
end
