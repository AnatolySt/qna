class AddBestFlagToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best_flag, :boolean, default: false
  end
end
