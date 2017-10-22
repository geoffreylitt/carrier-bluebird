# every tweet is associated w/ a user who we synced it for.

class AddSyncedUserIdToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :synced_user_id, :integer
  end
end
