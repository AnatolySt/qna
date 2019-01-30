class AddUserIdAndQuestionIdToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_reference :subscriptions, :user, foreign_key: true
    add_reference :subscriptions, :question, foreign_key: true
  end
end
