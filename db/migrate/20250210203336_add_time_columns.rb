class AddTimeColumns < ActiveRecord::Migration[8.0]
  def up
    remove_column :games, :started_at
    remove_column :games, :ended_at

    add_column :games, :start_time_seconds, :integer
    add_column :games, :end_time_seconds, :integer
    add_column :kills, :time_seconds, :integer
  end

  def down
    remove_column :games, :start_time_seconds
    remove_column :games, :end_time_seconds
    remove_column :kills, :time_seconds

    add_column :games, :started_at, :datetime
    add_column :games, :ended_at, :datetime
  end
end
