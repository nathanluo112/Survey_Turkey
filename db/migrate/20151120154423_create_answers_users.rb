class CreateAnswersUsers < ActiveRecord::Migration
  def change
    create_table :answers_users do |t|
      t.integer :user_id, null:false
      t.integer :answer_id, null:false
    end
  end
end
