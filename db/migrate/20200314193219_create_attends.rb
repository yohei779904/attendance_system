class CreateAttends < ActiveRecord::Migration[5.2]
  def change
    create_table :attends do |t|
      t.date :worked_day
      t.datetime :in
      t.datetime :out
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
