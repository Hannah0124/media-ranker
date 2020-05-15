class AddUserIdToVotes < ActiveRecord::Migration[6.0]
  def change
    add_reference :votes, :user, foregin_key: true
  end
end
