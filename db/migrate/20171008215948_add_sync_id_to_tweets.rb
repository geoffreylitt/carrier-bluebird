class AddSyncIdToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :sync_id, :string
  end
end
