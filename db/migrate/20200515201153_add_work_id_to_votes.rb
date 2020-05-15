class AddWorkIdToVotes < ActiveRecord::Migration[6.0]
  def change
    add_reference :votes, :work, foregin_key: true
  end
end
