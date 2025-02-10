class CreateTables < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :total_kills, default: 0
      t.timestamps
    end

    create_table :players do |t|
      t.string :username, null: false
      t.timestamps
    end

    create_table :death_causes do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.timestamps
    end

    create_table :kills do |t|
      t.references :game, null: false
      t.references :killer
      t.references :victim, null: false
      t.references :death_cause, null: false
      t.boolean :world_kill, default: false
      t.timestamps
    end
  end
end
