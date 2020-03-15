class AddBasicInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :basic_time, :datetime, default: Time.current.change(hour: 8, min: 0, sec: 0)
  end
end
