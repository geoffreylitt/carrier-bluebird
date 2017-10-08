class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.json :raw_data
      t.bigint :twitter_id
      t.datetime :created_at
      t.datetime :synced_at
    end
  end
end
