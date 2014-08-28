class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :fog_bugz_id
      t.string :title
      t.integer :estimate
      t.string :lane
      t.string :status
      t.string :shepherd
      t.string :board
      t.string :comments

      t.timestamps
    end
  end
end
